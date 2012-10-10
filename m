Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab2JJEvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 00:51:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:42874 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2JJEvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 00:51:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,563,1344236400"; 
   d="scan'208";a="224784680"
From: Jenny TC <jenny.tc@intel.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-kernel@vger.kernel.org
Cc: jenny.tc@intel.com
Subject: [PATCH] extcon : add charger supported as per spec
Date: Wed, 10 Oct 2012 15:51:48 +0530
Message-Id: <1349864508-21382-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for cable names as per USB charging spec 1.2
Also add cable name for AC adapter. This standardises the
cable names

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 drivers/extcon/extcon-class.c |    5 +++++
 include/linux/extcon.h        |    5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 3d8e825..7188daf 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -42,6 +42,11 @@
  * names that are actually used in your extcon device.
  */
 const char *extcon_cable_name[] = {
+	[EXTCON_SDP]		= "CHARGER_USB_SDP",
+	[EXTCON_DCP]		= "CHARGER_USB_DCP",
+	[EXTCON_CDP]		= "CHARGER_USB_CDP",
+	[EXTCON_ACA]		= "CHARGER_USB_ACA",
+	[EXTCON_AC]		= "CHARGER_AC",
 	[EXTCON_USB]		= "USB",
 	[EXTCON_USB_HOST]	= "USB-Host",
 	[EXTCON_TA]		= "TA",
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 9be8286..073fd49 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -53,6 +53,11 @@ enum extcon_cable_name {
 	EXTCON_FAST_CHARGER,
 	EXTCON_SLOW_CHARGER,
 	EXTCON_CHARGE_DOWNSTREAM, /* Charging an external device */
+	EXTCON_SDP,
+	EXTCON_DCP,
+	EXTCON_CDP,
+	EXTCON_ACA,
+	EXTCON_AC,
 	EXTCON_HDMI,
 	EXTCON_MHL,
 	EXTCON_DVI,
-- 
1.7.9.5

