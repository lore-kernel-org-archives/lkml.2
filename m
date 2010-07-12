Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab0GLUwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:52:06 -0400
Received: from mail.perches.com ([173.55.12.10]:1799 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab0GLUvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:51:11 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH 34/36] sound/soc/blackfin: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:26 -0700
Message-Id: <1c7c609ba4910da572c7888069707548af187651.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/soc/blackfin/bf5xx-ac97.c |    6 ++----
 sound/soc/blackfin/bf5xx-tdm.c  |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-ac97.c b/sound/soc/blackfin/bf5xx-ac97.c
index 523b7fc..c0eba51 100644
--- a/sound/soc/blackfin/bf5xx-ac97.c
+++ b/sound/soc/blackfin/bf5xx-ac97.c
@@ -255,8 +255,7 @@ EXPORT_SYMBOL_GPL(soc_ac97_ops);
 #ifdef CONFIG_PM
 static int bf5xx_ac97_suspend(struct snd_soc_dai *dai)
 {
-	struct sport_device *sport =
-		(struct sport_device *)dai->private_data;
+	struct sport_device *sport = dai->private_data;
 
 	pr_debug("%s : sport %d\n", __func__, dai->id);
 	if (!dai->active)
@@ -271,8 +270,7 @@ static int bf5xx_ac97_suspend(struct snd_soc_dai *dai)
 static int bf5xx_ac97_resume(struct snd_soc_dai *dai)
 {
 	int ret;
-	struct sport_device *sport =
-		(struct sport_device *)dai->private_data;
+	struct sport_device *sport = dai->private_data;
 
 	pr_debug("%s : sport %d\n", __func__, dai->id);
 	if (!dai->active)
diff --git a/sound/soc/blackfin/bf5xx-tdm.c b/sound/soc/blackfin/bf5xx-tdm.c
index 4b36012..24c1426 100644
--- a/sound/soc/blackfin/bf5xx-tdm.c
+++ b/sound/soc/blackfin/bf5xx-tdm.c
@@ -210,8 +210,7 @@ static int bf5xx_tdm_set_channel_map(struct snd_soc_dai *dai,
 #ifdef CONFIG_PM
 static int bf5xx_tdm_suspend(struct snd_soc_dai *dai)
 {
-	struct sport_device *sport =
-		(struct sport_device *)dai->private_data;
+	struct sport_device *sport = dai->private_data;
 
 	if (!dai->active)
 		return 0;
@@ -225,8 +224,7 @@ static int bf5xx_tdm_suspend(struct snd_soc_dai *dai)
 static int bf5xx_tdm_resume(struct snd_soc_dai *dai)
 {
 	int ret;
-	struct sport_device *sport =
-		(struct sport_device *)dai->private_data;
+	struct sport_device *sport = dai->private_data;
 
 	if (!dai->active)
 		return 0;
-- 
1.7.1.337.g6068.dirty

