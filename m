Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab0LMVmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:42:32 -0500
Received: from mail.perches.com ([173.55.12.10]:2580 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621Ab0LMVmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:42:31 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH 5/5] sound: ml403-ac97cr: Use vsprintf extension %pR for struct resource
Date: Mon, 13 Dec 2010 13:42:22 -0800
Message-Id: <2be0b943f9cb392d53880bebcc7c9b651520e024.1292276119.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292276119.git.joe@perches.com>
References: <cover.1292276119.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/drivers/ml403-ac97cr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/drivers/ml403-ac97cr.c b/sound/drivers/ml403-ac97cr.c
index a1282c1..5cfcb90 100644
--- a/sound/drivers/ml403-ac97cr.c
+++ b/sound/drivers/ml403-ac97cr.c
@@ -1143,8 +1143,8 @@ snd_ml403_ac97cr_create(struct snd_card *card, struct platform_device *pfdev,
 					     (resource->start) + 1);
 	if (ml403_ac97cr->port == NULL) {
 		snd_printk(KERN_ERR SND_ML403_AC97CR_DRIVER ": "
-			   "unable to remap memory region (%x to %x)\n",
-			   resource->start, resource->end);
+			   "unable to remap memory region (%pR)\n",
+			   resource);
 		snd_ml403_ac97cr_free(ml403_ac97cr);
 		return -EBUSY;
 	}
-- 
1.7.3.3.398.g0b0cd.dirty

