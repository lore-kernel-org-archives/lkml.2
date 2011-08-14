Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab1HNAAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 20:00:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60092 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1HNAAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 20:00:22 -0400
Subject: [PATCH] ASoC: soc-pcm: Remove unused global mutex
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Aug 2011 08:00:12 +0800
Message-ID: <1313280012.4112.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit b8c0dab9bf3373010e857a8d3f1b594c60a348dd
"ASoC: core - PCM mutex per rtd",
the global pcm_mutex is not being used any more.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/soc-pcm.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index b575939..1347584 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -27,8 +27,6 @@
 #include <sound/soc.h>
 #include <sound/initval.h>
 
-static DEFINE_MUTEX(pcm_mutex);
-
 static int soc_pcm_apply_symmetry(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-- 
1.7.4.1



