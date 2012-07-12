Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161616Ab2GLVwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:52:37 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57451 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821Ab2GLVvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:51:02 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/8] staging: ft1000-usb: Remove commented lines from ft1000_device.
Date: Thu, 12 Jul 2012 23:50:44 +0200
Message-Id: <1342129850-32209-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
References: <1342129850-32209-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 51c0847..d4f1aa1 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -74,10 +74,6 @@ struct ft1000_device
 
 	u8 bulk_in_endpointAddr;
 	u8 bulk_out_endpointAddr;
-
-	//struct ft1000_ethernet_configuration configuration;
-
-//	struct net_device_stats stats; //mbelian
 } __attribute__ ((packed));
 
 struct ft1000_debug_dirs {
-- 
1.7.9.5

