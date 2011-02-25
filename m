Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab1BYFTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 00:19:34 -0500
Received: from adelie.canonical.com ([91.189.90.139]:45883 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1BYFTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 00:19:32 -0500
From: Keng-Yu Lin <keng-yu.lin@canonical.com>
To: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tyson.chen@canonical.com, Keng-Yu Lin <keng-yu.lin@canonical.com>
Subject: [PATCH] eeepc-wmi: set the touchpad toggle key code to F21
Date: Fri, 25 Feb 2011 13:19:00 +0800
Message-Id: <1298611140-21573-1-git-send-email-keng-yu.lin@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
---
 drivers/platform/x86/eeepc-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

https://bugs.freedesktop.org/show_bug.cgi?id=31333

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index d399775..da00cbc 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -113,7 +113,7 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_KEY, 0x32, { KEY_MUTE } },
 	{ KE_KEY, 0x5c, { KEY_F15 } }, /* Power Gear key */
 	{ KE_KEY, 0x5d, { KEY_WLAN } },
-	{ KE_KEY, 0x6b, { KEY_F13 } }, /* Disable Touchpad */
+	{ KE_KEY, 0x6b, { KEY_F21 } }, /* Disable Touchpad */
 	{ KE_KEY, 0x82, { KEY_CAMERA } },
 	{ KE_KEY, 0x83, { KEY_CAMERA_ZOOMIN } },
 	{ KE_KEY, 0x88, { KEY_WLAN } },
-- 
1.7.1

