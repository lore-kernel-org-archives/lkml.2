Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab1LOH2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:28:54 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:43803 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab1LOH2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:28:39 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] asus-laptop: add some keys found on Lenovo SL500
Date: Thu, 15 Dec 2011 08:27:38 +0100
Message-Id: <1323934059-1221-9-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
References: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentin.chary@gmail.com>

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 847c8ad..c387a64 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -297,6 +297,7 @@ static const struct key_entry asus_keymap[] = {
 	{KE_KEY, 0x02, { KEY_SCREENLOCK } },
 	{KE_KEY, 0x05, { KEY_WLAN } },
 	{KE_KEY, 0x08, { KEY_F13 } },
+	{KE_KEY, 0x09, { KEY_PROG2 } }, /* Dock */
 	{KE_KEY, 0x17, { KEY_ZOOM } },
 	{KE_KEY, 0x1f, { KEY_BATTERY } },
 	/* End of Lenovo SL Specific keycodes */
@@ -322,6 +323,8 @@ static const struct key_entry asus_keymap[] = {
 	{KE_KEY, 0x62, { KEY_SWITCHVIDEOMODE } },
 	{KE_KEY, 0x63, { KEY_SWITCHVIDEOMODE } },
 	{KE_KEY, 0x6B, { KEY_F13 } }, /* Lock Touchpad */
+	{KE_KEY, 0x6C, { KEY_SLEEP } }, /* Suspend */
+	{KE_KEY, 0x6D, { KEY_SLEEP } }, /* Hibernate */
 	{KE_KEY, 0x7E, { KEY_BLUETOOTH } },
 	{KE_KEY, 0x7D, { KEY_BLUETOOTH } },
 	{KE_KEY, 0x82, { KEY_CAMERA } },
-- 
1.7.5.4

