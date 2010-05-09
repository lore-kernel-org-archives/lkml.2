Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0EIULK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:11:10 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:34651 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0EIULG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:11:06 -0400
Message-ID: <4BE716C1.3030305@udo.edu>
Date: Sun, 09 May 2010 22:10:41 +0200
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: alex.pototskiy@gmail.com, tiwai@suse.de, tdavis@dsl-only.net,
       linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org
Subject: [PATCH] snd-hda-intel: add support for Lenovo ThinkPad X100e in conexant
 codec
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ideapad quirks working for my ThinkPad X100e (microphone is not tested).

Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
---
  sound/pci/hda/patch_conexant.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 56e5207..b56c52a 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -2847,6 +2847,7 @@ static struct snd_pci_quirk cxt5066_cfg_tbl[] = {
         SND_PCI_QUIRK(0x1179, 0xff50, "Toshiba Satellite 
P500-PSPGSC-01800T", CXT5066_OLPC_XO_1_5),
         SND_PCI_QUIRK(0x1179, 0xffe0, "Toshiba Satellite Pro T130-15F", 
CXT5066_OLPC_XO_1_5),
         SND_PCI_QUIRK(0x17aa, 0x3a0d, "ideapad", CXT5066_IDEAPAD),
+       SND_PCI_QUIRK(0x17aa, 0x21b2, "ideapad", CXT5066_IDEAPAD), // X100e
         {}
  };

-- 
1.7.1
