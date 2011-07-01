Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1GAJgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:36:33 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:40029 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab1GAJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:35:30 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS NOTEBOOKS
	AN...),
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 10/16] asus-wmi: add some device ids
Date: Fri,  1 Jul 2011 11:34:35 +0200
Message-Id: <1309512881-2901-11-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 332103b..a972d8e 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -95,6 +95,7 @@ MODULE_LICENSE("GPL");
 /* Wireless */
 #define ASUS_WMI_DEVID_HW_SWITCH	0x00010001
 #define ASUS_WMI_DEVID_WIRELESS_LED	0x00010002
+#define ASUS_WMI_DEVID_CWAP		0x00010003
 #define ASUS_WMI_DEVID_WLAN		0x00010011
 #define ASUS_WMI_DEVID_BLUETOOTH	0x00010013
 #define ASUS_WMI_DEVID_GPS		0x00010015
@@ -104,6 +105,12 @@ MODULE_LICENSE("GPL");
 
 /* Leds */
 /* 0x000200XX and 0x000400XX */
+#define ASUS_WMI_DEVID_LED1		0x00020011
+#define ASUS_WMI_DEVID_LED2		0x00020012
+#define ASUS_WMI_DEVID_LED3		0x00020013
+#define ASUS_WMI_DEVID_LED4		0x00020014
+#define ASUS_WMI_DEVID_LED5		0x00020015
+#define ASUS_WMI_DEVID_LED6		0x00020016
 
 /* Backlight and Brightness */
 #define ASUS_WMI_DEVID_BACKLIGHT	0x00050011
-- 
1.7.3.4

