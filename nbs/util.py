
import os, pickle

def create_dictionary(*data):
    phrases = {}
    for d in data:
        for sentence in d:
            for ph in sentence.split(" "):
                phrases[ph] = True
    with open(os.path.join(path, "dictionary.txt"), "w") as fh:
        fh.writelines([ ph + "\n" for ph in phrases.keys() ])
    !cd $path; mkdir -p models; ln ../fasttext/wiki.zh.bin models/wiki.zh.bin
    !cd $path; ../../../bin/fasttext print-word-vectors models/wiki.zh.bin < dictionary.txt > dictionary.vec
    dictionary = pd.read_csv(os.path.join(path, "dictionary.vec"),
                             delim_whitespace=True, engine="python", header=None, index_col=0)
    with open(dictionary_path, "wb") as fh:
        pickle.dump([{ ph: i for i, ph in enumerate(dictionary.index) }, dictionary], fh)

def load_dictionary():
    with open(dictionary_path, "rb") as fh:
        [ dict_index, dictionary ] = pickle.load(fh)
        return dict_index, dictionary
