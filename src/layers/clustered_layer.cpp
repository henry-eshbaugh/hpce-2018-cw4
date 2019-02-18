#include "layer.hpp"
#include "tbb/parallel_for.h"

class ClusteredLayer
    : public Layer
{
protected:
    unsigned m_nIn;
    unsigned m_nOut;

    std::vector<synapse_t> *assoc_synapses;
public:
    ClusteredLayer(
        unsigned nIn,
        unsigned nOut,
        const std::vector<synapse_t> &synapses
    )
        : m_nIn(nIn)
        , m_nOut(nOut)
    {
	// build an associative array of synapses
    	assoc_synapses = new std::vector<synapse_t>[m_nOut];
	for (unsigned i = 0; i < synapses.size(); i++)
		assoc_synapses[synapses[i].dst].push_back(synapses[i]);
    }

    ~ClusteredLayer() { delete [] assoc_synapses; }
   
    const char *name() const
    { return "par_for_naive"; }
    
    virtual unsigned input_size() const
    { return m_nIn; }
    
    virtual unsigned output_size() const
    { return m_nOut; }
    
    void execute(
        const int8_t *pIn,  // Values of input neurons in -127..+127
        int8_t *pOut        // Values of output neurons in -127..+127
    ) const
    {        
	for (unsigned i = 0u; i < m_nOut; i++) {
            int32_t acc = 0;
	    for (auto synapse = assoc_synapses[i].begin(); synapse != assoc_synapses[i].end(); synapse++)
	    	acc += (synapse->weight * pIn[synapse->src]) >> (23-16);
            pOut[i] = sigmoid(acc); // compress with sigmoid
        }
    }
};

LayerPtr CreateClusteredLayer(unsigned nIn, unsigned nOut, const std::vector<synapse_t> &synapses)
{
    return std::make_shared<ClusteredLayer>(nIn, nOut, synapses);
}
