Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0GNMl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 08:41:27 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:43685 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756807Ab0GNMlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 08:41:22 -0400
Date: Wed, 14 Jul 2010 14:41:20 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Tejun Heo <tj@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 09/11] Removing dead ETRAX_NETWORK_RED_ON_NO_CONNECTION
Message-ID: <d8e76e2563bb1ced76b1629859a7dc02e8f2523c.1279110895.git.siccegge@cs.fau.de>
References: <cover.1279110894.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279110894.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ETRAX_NETWORK_RED_ON_NO_CONNECTION doesn't exist in Kconfig, therefore
removing all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/net/cris/eth_v10.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 7e00027..81475cc 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -1702,11 +1702,7 @@ e100_set_network_leds(int active)
 
 	if (!current_speed) {
 		/* Make LED red, link is down */
-#if defined(CONFIG_ETRAX_NETWORK_RED_ON_NO_CONNECTION)
-		CRIS_LED_NETWORK_SET(CRIS_LED_RED);
-#else
 		CRIS_LED_NETWORK_SET(CRIS_LED_OFF);
-#endif
 	} else if (light_leds) {
 		if (current_speed == 10) {
 			CRIS_LED_NETWORK_SET(CRIS_LED_ORANGE);
-- 
1.7.0.4

