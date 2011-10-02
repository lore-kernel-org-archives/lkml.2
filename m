Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1JBJlz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 05:41:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35761 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1JBJlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 05:41:50 -0400
Subject: [PATCH 1/3] ASoC: tegra: Staticise tegra_i2s_dai and
 tegra_spdif_dai
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stephen Warren <swarren@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 17:41:40 +0800
Message-ID: <1317548500.16362.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/tegra/tegra_i2s.c   |    2 +-
 sound/soc/tegra/tegra_spdif.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/tegra/tegra_i2s.c b/sound/soc/tegra/tegra_i2s.c
index f36b996..6728fab 100644
--- a/sound/soc/tegra/tegra_i2s.c
+++ b/sound/soc/tegra/tegra_i2s.c
@@ -312,7 +312,7 @@ static struct snd_soc_dai_ops tegra_i2s_dai_ops = {
 	.trigger	= tegra_i2s_trigger,
 };
 
-struct snd_soc_dai_driver tegra_i2s_dai[] = {
+static struct snd_soc_dai_driver tegra_i2s_dai[] = {
 	{
 		.name = DRV_NAME ".0",
 		.probe = tegra_i2s_probe,
diff --git a/sound/soc/tegra/tegra_spdif.c b/sound/soc/tegra/tegra_spdif.c
index abe606b..1bd07d1 100644
--- a/sound/soc/tegra/tegra_spdif.c
+++ b/sound/soc/tegra/tegra_spdif.c
@@ -232,7 +232,7 @@ static struct snd_soc_dai_ops tegra_spdif_dai_ops = {
 	.trigger	= tegra_spdif_trigger,
 };
 
-struct snd_soc_dai_driver tegra_spdif_dai = {
+static struct snd_soc_dai_driver tegra_spdif_dai = {
 	.name = DRV_NAME,
 	.probe = tegra_spdif_probe,
 	.playback = {
-- 
1.7.4.1



