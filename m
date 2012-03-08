Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab2CHFcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 00:32:10 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32772 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab2CHFbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 00:31:52 -0500
From: Il Han <corone.il.han@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Il Han <corone.il.han@gmail.com>
Subject: [PATCH] wm9090: remove unnecessary variables.
Date: Thu,  8 Mar 2012 14:27:41 +0900
Message-Id: <1331184461-25103-1-git-send-email-corone.il.han@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unnecessary variables which are not used left.

Remove them.

Signed-off-by: Il Han <corone.il.han@gmail.com>
---
 sound/soc/codecs/wm9090.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm9090.c b/sound/soc/codecs/wm9090.c
index 41ebe0d..eb09422 100644
--- a/sound/soc/codecs/wm9090.c
+++ b/sound/soc/codecs/wm9090.c
@@ -493,7 +493,6 @@ static int wm9090_set_bias_level(struct snd_soc_codec *codec,
 				 enum snd_soc_bias_level level)
 {
 	u16 *reg_cache = codec->reg_cache;
-	int i, ret;
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
-- 
1.7.4.1

