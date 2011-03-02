Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1CBNYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 08:24:43 -0500
Received: from smtp.nokia.com ([147.243.1.47]:57380 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab1CBNYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 08:24:41 -0500
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: peter.ujfalusi@nokia.com, tony@atomide.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 2/2] mfd: twl4030_codec: Remove unused and duplicate audio_mclk fields
Date: Wed,  2 Mar 2011 15:24:06 +0200
Message-Id: <1299072246-26402-3-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1299072246-26402-1-git-send-email-ilkka.koskinen@nokia.com>
References: <1299072246-26402-1-git-send-email-ilkka.koskinen@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audio_mclk can be queried from mfd driver. Therefore, it is not
needed in twl4030_codec_audio_data or in twl4030_codec_vibra_data
anymore.

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
---
 include/linux/i2c/twl.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 61b9609..9d88b71 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -637,7 +637,6 @@ extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
 extern int twl4030_remove_script(u8 flags);
 
 struct twl4030_codec_audio_data {
-	unsigned int audio_mclk; /* not used, will be removed */
 	unsigned int digimic_delay; /* in ms */
 	unsigned int ramp_delay_value;
 	unsigned int offset_cncl_path;
@@ -648,7 +647,6 @@ struct twl4030_codec_audio_data {
 };
 
 struct twl4030_codec_vibra_data {
-	unsigned int	audio_mclk;
 	unsigned int	coexist;
 };
 
-- 
1.7.0.4

