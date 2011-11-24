Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1KXKri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:47:38 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47031 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1KXKrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:47:37 -0500
Message-ID: <1322131645.2467.2.camel@phoenix>
Subject: [PATCH] ALSA: Convert mips directory to module_platform_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Date: Thu, 24 Nov 2011 18:47:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out some boilerplate code.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This is a resend of "ASoC: Convert mips directory to module_platform_driver".
Fix the subject line and Cc Takashi.

Axel
 sound/mips/hal2.c       |   13 +------------
 sound/mips/sgio2audio.c |   13 +------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/sound/mips/hal2.c b/sound/mips/hal2.c
index 2e6c858..5f88d1f 100644
--- a/sound/mips/hal2.c
+++ b/sound/mips/hal2.c
@@ -935,15 +935,4 @@ static struct platform_driver hal2_driver = {
 	}
 };
 
-static int __init alsa_card_hal2_init(void)
-{
-	return platform_driver_register(&hal2_driver);
-}
-
-static void __exit alsa_card_hal2_exit(void)
-{
-	platform_driver_unregister(&hal2_driver);
-}
-
-module_init(alsa_card_hal2_init);
-module_exit(alsa_card_hal2_exit);
+module_platform_driver(hal2_driver);
diff --git a/sound/mips/sgio2audio.c b/sound/mips/sgio2audio.c
index 69425d4..ceaa593 100644
--- a/sound/mips/sgio2audio.c
+++ b/sound/mips/sgio2audio.c
@@ -976,15 +976,4 @@ static struct platform_driver sgio2audio_driver = {
 	}
 };
 
-static int __init alsa_card_sgio2audio_init(void)
-{
-	return platform_driver_register(&sgio2audio_driver);
-}
-
-static void __exit alsa_card_sgio2audio_exit(void)
-{
-	platform_driver_unregister(&sgio2audio_driver);
-}
-
-module_init(alsa_card_sgio2audio_init)
-module_exit(alsa_card_sgio2audio_exit)
+module_platform_driver(sgio2audio_driver);
-- 
1.7.5.4



