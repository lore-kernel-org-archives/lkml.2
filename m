Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1CKKlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 05:41:12 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:34865 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1CKKlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 05:41:08 -0500
Subject: [PATCH] intel8x0m: append 'm' to "r_intel8x0"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Fri, 11 Mar 2011 11:41:06 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.91 (2.91.91-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1299840066.12153.11.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Appending an 'm' will distinguish it from a similar struct in intel8x0.c

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 sound/pci/intel8x0m.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index e16b3e9..ae31655 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -1108,7 +1108,7 @@ struct ich_reg_info {
 static int __devinit snd_intel8x0m_create(struct snd_card *card,
 					 struct pci_dev *pci,
 					 unsigned long device_type,
-					 struct intel8x0m ** r_intel8x0)
+					 struct intel8x0m **r_intel8x0m)
 {
 	struct intel8x0m *chip;
 	int err;
@@ -1124,7 +1124,7 @@ static int __devinit snd_intel8x0m_create(struct snd_card *card,
 	};
 	struct ich_reg_info *tbl;
 
-	*r_intel8x0 = NULL;
+	*r_intel8x0m = NULL;
 
 	if ((err = pci_enable_device(pci)) < 0)
 		return err;
@@ -1237,7 +1237,7 @@ static int __devinit snd_intel8x0m_create(struct snd_card *card,
 
 	snd_card_set_dev(card, &pci->dev);
 
-	*r_intel8x0 = chip;
+	*r_intel8x0m = chip;
 	return 0;
 }
 
-- 
1.7.4.1



