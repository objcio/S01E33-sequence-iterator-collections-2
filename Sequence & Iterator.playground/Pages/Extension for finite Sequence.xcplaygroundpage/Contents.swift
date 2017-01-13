extension Sequence {
    func split(batchSize: Int) -> [[Iterator.Element]] {
        var result: [[Iterator.Element]] = []
        var batch: [Iterator.Element] = []
        for element in self {
            batch.append(element)
            if batch.count == batchSize {
                result.append(batch)
                batch = []
            }
        }
        if !batch.isEmpty { result.append(batch) }
        return result
    }
}


import Foundation
final class ReadRandom: IteratorProtocol {
    let handle = FileHandle(forReadingAtPath: "/dev/urandom")!
    
    deinit {
        handle.closeFile()
    }
    
    func next() -> UInt8? {
        let data = handle.readData(ofLength: 1)
        return data[0]
    }
}

let randomSequence = AnySequence { ReadRandom() }
var result = randomSequence.prefix(10).split(batchSize: 3)
