Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab1JSPIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:08:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42616 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab1JSPIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:08:21 -0400
Message-ID: <1319036893.7741.3.camel@phoenix>
Subject: [PATCH RESEND] ASoC: ak4641: Remove unused codec field from struct
 ak4641_priv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Harald Welte <laforge@gnumonks.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Dmitry Artamonow <mad_soft@inbox.ru>, alsa-devel@alsa-project.org
Date: Wed, 19 Oct 2011 23:08:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Sorry. a typo in subject line. here is a resend.

 sound/soc/codecs/ak4641.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/ak4641.c b/sound/soc/codecs/ak4641.c
index 7a64e58..f5125ae 100644
--- a/sound/soc/codecs/ak4641.c
+++ b/sound/soc/codecs/ak4641.c
@@ -31,7 +31,6 @@
 
 /* codec private data */
 struct ak4641_priv {
-	struct snd_soc_codec *codec;
 	unsigned int sysclk;
 	int deemph;
 	int playback_fs;
-- 
1.7.5.4



