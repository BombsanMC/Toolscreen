#pragma once

#include "features/ninjabrain_api.h"

void StartNinjabrainClient();
void StopNinjabrainClient();
void StopNinjabrainClientAsync();
void RestartNinjabrainClient();
void RestartNinjabrainClientAsync();
NinjabrainApiStatus GetNinjabrainClientStatus();