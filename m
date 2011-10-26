Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1JZBx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:53:56 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43997 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab1JZBxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:53:55 -0400
Message-ID: <1319594021.2517.0.camel@phoenix>
Subject: [PATCH 1/2] ASoC: wm8940: Properly set codec->dapm.bias_level
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Paulson-Ellis <chris@edesix.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Wed, 26 Oct 2011 09:53:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Chris Paulson-Ellis <chris@edesix.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8940.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index fec3892..e8a4ca3 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -488,6 +488,8 @@ static int wm8940_set_bias_level(struct snd_soc_codec *codec,
 		break;
 	}
 
+	codec->dapm.bias_level = level;
+
 	return ret;
 }
 
-- 
1.7.5.4



