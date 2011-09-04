Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1IDK1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:27:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54910 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1IDK0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:23 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 06/12] staging: et131x: Remove registry_rx_mem_end from struct et131x_adapter
Date: Sun,  4 Sep 2011 11:24:37 +0100
Message-Id: <1315131883-11068-7-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

registry_rx_mem_end is not referenced anywhere in the driver.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_adapter.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 5656472..8c6d5f9 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -136,7 +136,6 @@ struct ce_stats {
 	u32		interrupt_status;
 };
 
-
 /* The private adapter structure */
 struct et131x_adapter {
 	struct net_device *netdev;
@@ -179,11 +178,8 @@ struct et131x_adapter {
 
 	/* Registry parameters */
 	u8 wanted_flow;		/* Flow we want for 802.3x flow control */
-
-	u32 registry_rx_mem_end;	/* Size of internal rx memory */
 	u32 registry_jumbo_packet;	/* Max supported ethernet packet size */
 
-
 	/* Derived from the registry: */
 	u8 ai_force_duplex;	/* duplex setting */
 	u16 ai_force_speed;	/* 'Speed', user over-ride of line speed */
-- 
1.7.6

