Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1AXQdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:33:37 -0500
Received: from fb2.tech.numericable.fr ([82.216.111.50]:38572 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1AXQdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:33:33 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 09/14] eeepc-wmi: reorder defines
Date: Mon, 24 Jan 2011 17:23:53 +0100
Message-Id: <1295886238-15961-10-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295886238-15961-1-git-send-email-corentincj@iksaif.net>
References: <1295886238-15961-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 1fc191b..aa9e1d1 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -60,20 +60,20 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("wmi:"EEEPC_WMI_EVENT_GUID);
 MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
 
-#define NOTIFY_BRNUP_MIN	0x11
-#define NOTIFY_BRNUP_MAX	0x1f
-#define NOTIFY_BRNDOWN_MIN	0x20
-#define NOTIFY_BRNDOWN_MAX	0x2e
+#define NOTIFY_BRNUP_MIN		0x11
+#define NOTIFY_BRNUP_MAX		0x1f
+#define NOTIFY_BRNDOWN_MIN		0x20
+#define NOTIFY_BRNDOWN_MAX		0x2e
 
-#define EEEPC_WMI_METHODID_DEVS	0x53564544
-#define EEEPC_WMI_METHODID_DSTS	0x53544344
-#define EEEPC_WMI_METHODID_CFVS	0x53564643
+#define EEEPC_WMI_METHODID_DSTS		0x53544344
+#define EEEPC_WMI_METHODID_DEVS		0x53564544
+#define EEEPC_WMI_METHODID_CFVS		0x53564643
 
-#define EEEPC_WMI_DEVID_BACKLIGHT	0x00050012
-#define EEEPC_WMI_DEVID_TPDLED		0x00100011
 #define EEEPC_WMI_DEVID_WLAN		0x00010011
 #define EEEPC_WMI_DEVID_BLUETOOTH	0x00010013
 #define EEEPC_WMI_DEVID_WWAN3G		0x00010019
+#define EEEPC_WMI_DEVID_BACKLIGHT	0x00050012
+#define EEEPC_WMI_DEVID_TPDLED		0x00100011
 
 static bool hotplug_wireless;
 
-- 
1.7.3.4

