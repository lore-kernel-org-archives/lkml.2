Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1FJLzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 07:55:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40582 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab1FJLzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 07:55:42 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v4 14/18] ASoC: twl6040: Support other sample rates in constraints.
Date: Fri, 10 Jun 2011 14:54:32 +0300
Message-ID: <1307706876-4768-15-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liam Girdwood <lrg@ti.com>

Add other supported sample rates to LP and HP modes.

Signed-off-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 28dc5d9..7845cdb 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -1203,6 +1203,13 @@ static int twl6040_set_bias_level(struct snd_soc_codec *codec,
 /* set of rates for each pll: low-power and high-performance */
 
 static unsigned int lp_rates[] = {
+	8000,
+	11250,
+	16000,
+	22500,
+	32000,
+	44100,
+	48000,
 	88200,
 	96000,
 };
@@ -1213,6 +1220,10 @@ static struct snd_pcm_hw_constraint_list lp_constraints = {
 };
 
 static unsigned int hp_rates[] = {
+	8000,
+	16000,
+	32000,
+	48000,
 	96000,
 };
 
-- 
1.7.5.3

