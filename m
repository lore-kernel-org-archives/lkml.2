Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab1BZJXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 04:23:38 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:48194 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab1BZJXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 04:23:34 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.34
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        platform-driver-x86@vger.kernel.org (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 14/14] eeepc-wmi: restore KEY_CAMERA_* keys lost in 190ca27
Date: Sat, 26 Feb 2011 10:20:43 +0100
Message-Id: <1298712045-17671-15-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
References: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index e69701f..64e36de 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -65,11 +65,17 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_KEY, 0x5d, { KEY_WLAN } },
 	{ KE_KEY, 0x6b, { KEY_F13 } }, /* Disable Touchpad */
 	{ KE_KEY, 0x82, { KEY_CAMERA } },
+	{ KE_KEY, 0x83, { KEY_CAMERA_ZOOMIN } },
 	{ KE_KEY, 0x88, { KEY_WLAN } },
 	{ KE_KEY, 0xcc, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0xe0, { KEY_PROG1 } }, /* Task Manager */
 	{ KE_KEY, 0xe1, { KEY_F14 } }, /* Change Resolution */
 	{ KE_KEY, 0xe9, { KEY_BRIGHTNESS_ZERO } },
+	{ KE_KEY, 0xeb, { KEY_CAMERA_ZOOMOUT } },
+	{ KE_KEY, 0xec, { KEY_CAMERA_UP } },
+	{ KE_KEY, 0xed, { KEY_CAMERA_DOWN } },
+	{ KE_KEY, 0xee, { KEY_CAMERA_LEFT } },
+	{ KE_KEY, 0xef, { KEY_CAMERA_RIGHT } },
 	{ KE_END, 0},
 };
 
-- 
1.7.4

