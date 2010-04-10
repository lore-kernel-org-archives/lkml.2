Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab0DJGzm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 02:55:42 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:58932 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0DJGzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 02:55:40 -0400
X-SENDER-IP: [83.226.251.151]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhM4ABu+v0tT4vuXPGdsb2JhbACHZZNdDAEBAQE1LapojWmFCgQ
X-IronPort-AV: E=Sophos;i="4.52,181,1270418400"; 
   d="scan'208";a="61860944"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, alan@linux.intel.com, o.hartmann@telovital.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: et131x: et1310_address_map.h Brace and space fix.
Date: Sat, 10 Apr 2010 08:55:37 +0200
Message-Id: <1270882537-16252-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed a space and a brace found by checkpatch.pl.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/et131x/et1310_address_map.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/et131x/et1310_address_map.h b/drivers/staging/et131x/et1310_address_map.h
index ea746ba..2848e48 100644
--- a/drivers/staging/et131x/et1310_address_map.h
+++ b/drivers/staging/et131x/et1310_address_map.h
@@ -1052,7 +1052,7 @@ typedef struct _RXMAC_t {				/* Location: */
  * 4-0: register
  */
 
-#define MII_ADDR(phy,reg)	((phy) << 8 | (reg))
+#define MII_ADDR(phy, reg)	((phy) << 8 | (reg))
 
 /*
  * structure for MII Management Control reg in mac address map.
@@ -1249,8 +1249,7 @@ typedef struct _MAC_t {					/* Location: */
 /*
  * MAC STATS Module of JAGCore Address Mapping
  */
-struct macstat_regs
-{					/* Location: */
+struct macstat_regs {			/* Location: */
 	u32 pad[32];			/*  0x6000 - 607C */
 
 	/* Tx/Rx 0-64 Byte Frame Counter */
-- 
1.7.0.4

