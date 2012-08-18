Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2HRITw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 04:19:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51693 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2HRITs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 04:19:48 -0400
From: anish kumar <anish198519851985@gmail.com>
To: myungjoo.ham@samsung.com
Cc: cw00.choi@samsung.com, linux-kernel@vger.kernel.org,
        anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] Extcon: Minor change in the declaration of cable_names
Date: Sat, 18 Aug 2012 13:49:24 +0530
Message-Id: <1345277964-7637-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

Instead of "const char **supported_cable" it is better to have
it as "const char *const *supported_cable".

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 include/linux/extcon.h                 |    2 +-
 include/linux/extcon/extcon-adc-jack.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index cdd4014..a6bcc29 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -111,7 +111,7 @@ struct extcon_cable;
 struct extcon_dev {
 	/* --- Optional user initializing data --- */
 	const char	*name;
-	const char **supported_cable;
+	const char *const *supported_cable;
 	const u32	*mutually_exclusive;
 
 	/* --- Optional callbacks to override class functions --- */
diff --git a/include/linux/extcon/extcon-adc-jack.h b/include/linux/extcon/extcon-adc-jack.h
index 20e9eef..f27f2e8 100644
--- a/include/linux/extcon/extcon-adc-jack.h
+++ b/include/linux/extcon/extcon-adc-jack.h
@@ -60,7 +60,7 @@ struct adc_jack_pdata {
 	/*
 	 * The last entry should be NULL
 	 */
-	const char **cable_names;
+	const char *const *cable_names;
 	/* The last entry's state should be 0 */
 	struct adc_jack_cond *adc_conditions;
 
-- 
1.7.1

