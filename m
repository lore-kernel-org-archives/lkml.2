Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595Ab0KRVfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:35:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57634 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab0KRVfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:35:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=LPEC3SKZtVsJaZzEIOj4FbMMxMVyyauy8nIG5lqw7qDWpguYrkZ7KDcObnFTOKEc9T
         WXDPsxmN48NkLQLYdXWVE4jyk4/bqiwCTmDsZLmHrAH35tsmOrwTafTWJpdrE+MBhbJL
         SbDV57aH8NK2V3PnVfo41uX5IMZzY/xRg2M/U=
MIME-Version: 1.0
Date: Thu, 18 Nov 2010 15:35:51 -0600
X-Google-Sender-Auth: Z8GwCE63s89UG_jftt7XkuSQwk0
Message-ID: <AANLkTin2zKWLLxsRn+T+U+NpAmbQiOTM_vrg_Z-8JZd-@mail.gmail.com>
Subject: [PATCH] Enable jack sense for Thinkpad Edge 11
From: Manoj Iyer <manoj.iyer@canonical.com>
To: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables audio play back from external headphones on Thinkpad Edge 11.

The following changes since commit 0c1c062266ecfeaebadadb780020a422f829284f:
  Manoj Iyer (1):
        Enable jack sense for Thinkpad Edge 11

are available in the git repository at:

  git://kernel.ubuntu.com/git/manjo/linux-2.6.git thinpad11

>From 89796b0608f0c36cbd05d0426e95386766ff20b9 Mon Sep 17 00:00:00 2001
From: Manoj Iyer <manoj.iyer@canonical.com>
Date: Thu, 18 Nov 2010 21:24:42 +0000
Subject: [PATCH] Enable jack sense for Thinkpad Edge 11

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 sound/pci/hda/patch_conexant.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 6361f75..b8d6554 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3108,6 +3108,7 @@ static struct snd_pci_quirk cxt5066_cfg_tbl[] = {
        SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT5066_OLPC_XO_1_5),
        SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400s", CXT5066_THINKPAD),
        SND_PCI_QUIRK(0x17aa, 0x21b2, "Thinkpad X100e", CXT5066_IDEAPAD),
+       SND_PCI_QUIRK(0x17aa, 0x21c8, "Thinkpad Edge 11", CXT5066_THINKPAD),
        SND_PCI_QUIRK(0x17aa, 0x21b3, "Thinkpad Edge 13 (197)",
CXT5066_IDEAPAD),
        SND_PCI_QUIRK(0x17aa, 0x21b4, "Thinkpad Edge", CXT5066_IDEAPAD),
        SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
-- 
1.7.0.4

---
Manoj Iyer
