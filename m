Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2JCJ1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:27:46 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:59312 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2JCJ1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:27:44 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] asus-laptop: map some new keys
Date: Wed,  3 Oct 2012 11:26:25 +0200
Message-Id: <1349256392-20320-3-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349256392-20320-1-git-send-email-corentin.chary@gmail.com>
References: <1349256392-20320-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    3 +++
 drivers/platform/x86/asus-nb-wmi.c |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 4b568df..68257ed 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -314,6 +314,8 @@ static const struct key_entry asus_keymap[] = {
 	{KE_KEY, 0x50, { KEY_EMAIL } },
 	{KE_KEY, 0x51, { KEY_WWW } },
 	{KE_KEY, 0x55, { KEY_CALC } },
+	{KE_IGNORE, 0x57, },  /* Battery mode */
+	{KE_IGNORE, 0x58, },  /* AC mode */
 	{KE_KEY, 0x5C, { KEY_SCREENLOCK } },  /* Screenlock */
 	{KE_KEY, 0x5D, { KEY_WLAN } },
 	{KE_KEY, 0x5E, { KEY_WLAN } },
@@ -325,6 +327,7 @@ static const struct key_entry asus_keymap[] = {
 	{KE_KEY, 0x6B, { KEY_F13 } }, /* Lock Touchpad */
 	{KE_KEY, 0x6C, { KEY_SLEEP } }, /* Suspend */
 	{KE_KEY, 0x6D, { KEY_SLEEP } }, /* Hibernate */
+	{KE_IGNORE, 0x6E, },  /* Low Battery notification */
 	{KE_KEY, 0x7E, { KEY_BLUETOOTH } },
 	{KE_KEY, 0x7D, { KEY_BLUETOOTH } },
 	{KE_KEY, 0x82, { KEY_CAMERA } },
diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index be79040..b70425c 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -185,6 +185,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x62, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0x63, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0x6B, { KEY_TOUCHPAD_TOGGLE } },
+	{ KE_IGNORE, 0x6E, },  /* Low Battery notification */
 	{ KE_KEY, 0x7D, { KEY_BLUETOOTH } },
 	{ KE_KEY, 0x7E, { KEY_BLUETOOTH } },
 	{ KE_KEY, 0x82, { KEY_CAMERA } },
-- 
1.7.8.6

