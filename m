Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1ABOWD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 09:22:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab1ABOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 09:21:53 -0500
From: Stefan Weil <weil@mail.berlios.de>
Cc: Stefan Weil <weil@mail.berlios.de>,
        Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix spelling milisec -> ms in module parameter description
Date: Sun,  2 Jan 2011 15:21:49 +0100
Message-Id: <1293978109-5288-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:TdZXfA0Nc9LtH082cjDZBQtrLSeD1aLDgjEDxI9smq/
 Xev6nW5PBEOmkII/eeprL9bW6secEsyCNJQSZMCK7U/ZOuH3Mh
 2M4ILe4UZ4LTXLbFMRoMtYD2RJgOG6nRY1rL4u2riWZNsaXMoW
 pDlCe+NT8+h8VZUPesuIZtFdMfs9/pEScuAzicR2PnhG82wYC+
 z0moiqlmR1F8GJ2rpHCsQiCEX3/yVmm1WMmW9AvtIAG8RBgdke
 +v3xA6cY2ES6n
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of replacing 'milisec' by 'millisec', I decided to use
the more common SI unit. Other drivers use 'milliseconds'
or 'ms', too ('millisec' is never used).

Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 sound/ppc/snd_ps3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
index 581a670..edce8a2 100644
--- a/sound/ppc/snd_ps3.c
+++ b/sound/ppc/snd_ps3.c
@@ -51,7 +51,7 @@ static struct snd_ps3_card_info the_card;
 static int snd_ps3_start_delay = CONFIG_SND_PS3_DEFAULT_START_DELAY;
 
 module_param_named(start_delay, snd_ps3_start_delay, uint, 0644);
-MODULE_PARM_DESC(start_delay, "time to insert silent data in milisec");
+MODULE_PARM_DESC(start_delay, "time to insert silent data in ms");
 
 static int index = SNDRV_DEFAULT_IDX1;
 static char *id = SNDRV_DEFAULT_STR1;
-- 
1.7.2.3

