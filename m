Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1BYGQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:16:04 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:65202 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1BYGQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:16:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fiffUrIWL70dxujphtGC6WvD0gqZAYX+rcSQsUq1UP1ZiDpftqvLhmJBVvm1FHBlmF
         0badQ89z87JObgnWsAPAxyhf6VQxgi9s3YL3R9gJ44uvbJ53YHj5mnLPsaKV7PA7hUBB
         ei2tkKtU9hMOe75pwwTrdADwJBLs/fzl2VgEk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 19/21]sound:pci:emu10k1:emu10k1_main.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:15:42 -0800
Message-Id: <1298614542-4192-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 sound/pci/emu10k1/emu10k1_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/emu10k1/emu10k1_main.c b/sound/pci/emu10k1/emu10k1_main.c
index 66c7fb3..5e619a8 100644
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -926,7 +926,7 @@ static int snd_emu10k1_emu1010_init(struct snd_emu10k1 *emu)
 	snd_emu1010_fpga_write(emu, EMU_HANA_MIDI_IN, 0x19);
 	/* Unknown. */
 	snd_emu1010_fpga_write(emu, EMU_HANA_MIDI_OUT, 0x0c);
-	/* IRQ Enable: Alll on */
+	/* IRQ Enable: All on */
 	/* snd_emu1010_fpga_write(emu, 0x09, 0x0f ); */
 	/* IRQ Enable: All off */
 	snd_emu1010_fpga_write(emu, EMU_HANA_IRQ_ENABLE, 0x00);
-- 
1.7.4.1

