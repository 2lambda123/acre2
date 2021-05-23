#include "Engine.h"
#include "Log.h"
#include "MumbleFunctions.h"
#include "compat.h"

//
// Handle a command event
//
bool mumble_onReceiveData(mumble_connection_t connection, mumble_userid_t sender, const uint8_t *data, size_t dataLength, const char *dataID) {
    if ((dataLength > 0U) && CEngine::getInstance()->getExternalServer()) {
		// TODO: Cast is probably unnecessary
        CEngine::getInstance()->getExternalServer()->handleMessage((unsigned char *) data, dataLength);
        return true;
    }
    return false;
}
