// Utils for validating federation requests

import { Errors } from "./errors"
import { isLocalServerName, isValidServerName } from "./ids"

export type XMatrixAuth = {
    origin: string | null;
    destination: string | null;
    key: string | null;
    sig: string | null;
}

export function parseAuthHeader(header: string, localServer: string): XMatrixAuth {
    if (!header.startsWith("X-Matrix ")) {
        throw Errors.unauthorized("Not X-Matrix auth")
    }
    const fields = header.split(" ")[1].split(",")
    const auth: XMatrixAuth = {
        origin: null,
        destination: null,
        key: null,
        sig: null
    }
    for (const field of  fields) {
        let [key, value] = field.split("=")
        // TODO: is it good to assume that the value is always quoted?
        // i believe that most or all servers do this consistently, but it could be a
        // footgun.
        value = value.substring(1, value.length - 1)
        switch (key) {
            case "origin":
                if (!isValidServerName(value)) {
                    throw Errors.invalidParam("Bad origin")
                }
                auth.origin = value
                break
            case "destination":
                if (!isLocalServerName(value, localServer)) {
                    throw Errors.invalidParam("Bad destination (not this server)")
                }
                auth.destination = value
                break
            case "key":
                // TODO: is this correct to enforce?
                if (value.split(":", 2).length < 2) {
                    throw Errors.invalidParam("Bad key identifier")
                }
                auth.key = value
                break
            case "sig":
                // NOTE: when the ed25519 stuff is done, remember to
                // keep signature validation out of here. it's just a parser
                auth.sig = value
                break
            default:
                break;
        }
    }
    return auth
}