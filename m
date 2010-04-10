Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab0DJHMI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 03:12:08 -0400
Received: from smtprelay-h11.telenor.se ([62.127.194.4]:60117 "EHLO
	smtprelay-h11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab0DJHMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 03:12:01 -0400
X-SENDER-IP: [83.226.251.151]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhM4AG3Bv0tT4vuXPGdsb2JhbACHZZNdDAEBAQE1LapfjWOFCgQ
X-IronPort-AV: E=Sophos;i="4.52,181,1270418400"; 
   d="scan'208";a="61851434"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, alan@linux.intel.com, o.hartmann@telovital.com,
       tj@kernel.org, cl@linux-foundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: et131x: et1310_phy.c coding style fixes.
Date: Sat, 10 Apr 2010 09:12:01 +0200
Message-Id: <1270883521-16933-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed some long lines and whitespace around a =.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/et131x/et1310_phy.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 34cd5d1..21c5eee 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -344,7 +344,7 @@ static void ET1310_PhyDuplexMode(struct et131x_adapter *etdev, u16 duplex)
 static void ET1310_PhySpeedSelect(struct et131x_adapter *etdev, u16 speed)
 {
 	u16 data;
-	static const u16 bits[3]={0x0000, 0x2000, 0x0040};
+	static const u16 bits[3] = {0x0000, 0x2000, 0x0040};
 
 	/* Read the PHY control register */
 	MiRead(etdev, PHY_CONTROL, &data);
@@ -760,7 +760,8 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 			if (etdev->linkspeed == TRUEPHY_SPEED_10MBPS) {
 				/* NOTE - Is there a way to query this without
 				 * TruePHY?
-				 * && TRU_QueryCoreType(etdev->hTruePhy, 0) == EMI_TRUEPHY_A13O) {
+				 * && TRU_QueryCoreType(etdev->hTruePhy, 0) ==
+				 * EMI_TRUEPHY_A13O) {
 				 */
 				u16 Register18;
 
@@ -778,7 +779,7 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 			 * in the LinkDetectionDPC).
 			 */
 			if (!(etdev->Flags & fMP_ADAPTER_LINK_DETECTION) ||
-			  (etdev->MediaState == NETIF_STATUS_MEDIA_DISCONNECT)) {
+			 (etdev->MediaState == NETIF_STATUS_MEDIA_DISCONNECT)) {
 				spin_lock_irqsave(&etdev->Lock, flags);
 				etdev->MediaState =
 				    NETIF_STATUS_MEDIA_DISCONNECT;
@@ -836,7 +837,8 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 				/*
 				 * NOTE - Is there a way to query this without
 				 * TruePHY?
-				 * && TRU_QueryCoreType(etdev->hTruePhy, 0)== EMI_TRUEPHY_A13O) {
+				 * && TRU_QueryCoreType(etdev->hTruePhy, 0)==
+				 * EMI_TRUEPHY_A13O) {
 				 */
 				u16 Register18;
 
-- 
1.7.0.4

