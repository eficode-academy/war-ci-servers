package main

import (
    "dagger.io/dagger"
    "dagger.io/dagger/core"
    "universe.dagger.io/bash"
    "universe.dagger.io/alpine"
)

dagger.#Plan & {
    actions: {
        _pull: core.#Pull & {source: "ubuntu"}
 //       hello: #AddHello & {
 //           dir: client.filesystem.".".read.contents
 //       }
        shellrun: #RunHello & {
            _build: alpine.#Build & {
			    packages: bash: _
		    }
		    image: _build.output
        }
    }
    client: filesystem: ".": {
        read: contents: dagger.#FS
        //write: contents: actions.hello.result
    }
}


// Write a greeting to a file, and add it to a directory
#AddHello: {
    // The input directory
    dir: dagger.#FS

    // The name of the person to greet
    name: string | *"world"

    write: core.#WriteFile & {
        input: dir
        path: "hello-\(name).txt"
        contents: "hello, \(name)!"
    }

    // The directory with greeting message added
    result: write.output
}
#RunHello:{
    image: image
    src: core.#Source & {
        path: "./ci"
    }
    bash.#Run & {
        input:image
        script: {
            directory: src.output
            filename: "build-app.sh"
        }
    }
}