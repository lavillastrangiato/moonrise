#if !defined(using_map_DATUM)

	#include "away_sites_testing_lobby.dm"
	#include "blank.dmm"

	#include "../../code/content_packages/government/away_sites/icarus/icarus.dm"
	#include "../../code/content_packages/corporate/away_sites/lar_maria/lar_maria.dm"

	#include "../away/empty.dmm"
	#include "../away/mining/mining.dm"
	#include "../away/derelict/derelict.dm"
	#include "../away/bearcat/bearcat.dm"
	#include "../away/lost_supply_base/lost_supply_base.dm"
	#include "../away/smugglers/smugglers.dm"
	#include "../away/casino/casino.dm"
	#include "../away/magshield/magshield.dm"
	#include "../away/slavers/slavers_base.dm"
	#include "../away/blueriver/blueriver.dm"
	#include "../away/mobius_rift/mobius_rift.dm"
	#include "../away/errant_pisces/errant_pisces.dm"
	#include "../away/unishi/unishi.dm"

	#define using_map_DATUM /datum/map/away_sites_testing

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Away Sites Testing

#endif
