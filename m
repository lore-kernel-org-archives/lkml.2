Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581Ab1IOMkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:40:49 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:47831 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933522Ab1IOMkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:33 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 09/17] ASoC: twl6040: Remove strings "NULL" from DAPM route
Date: Thu, 15 Sep 2011 15:39:31 +0300
Message-Id: <1316090379-30760-10-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316090379-30760-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the string with plain NULL.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 9d1f82d..689e88b 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -1195,8 +1195,8 @@ static const struct snd_soc_dapm_route intercon[] = {
 	{"ADC Right", NULL, "MicAmpR"},
 
 	/* AFM path */
-	{"AFMAmpL", "NULL", "AFML"},
-	{"AFMAmpR", "NULL", "AFMR"},
+	{"AFMAmpL", NULL, "AFML"},
+	{"AFMAmpR", NULL, "AFMR"},
 
 	{"HS Left Playback", "HS DAC", "HSDAC Left"},
 	{"HS Left Playback", "Line-In amp", "AFMAmpL"},
@@ -1204,8 +1204,8 @@ static const struct snd_soc_dapm_route intercon[] = {
 	{"HS Right Playback", "HS DAC", "HSDAC Right"},
 	{"HS Right Playback", "Line-In amp", "AFMAmpR"},
 
-	{"Headset Left Driver", "NULL", "HS Left Playback"},
-	{"Headset Right Driver", "NULL", "HS Right Playback"},
+	{"Headset Left Driver", NULL, "HS Left Playback"},
+	{"Headset Right Driver", NULL, "HS Right Playback"},
 
 	{"HSOL", NULL, "Headset Left Driver"},
 	{"HSOR", NULL, "Headset Right Driver"},
-- 
1.7.6.1

