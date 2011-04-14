Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908Ab1DNSXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:23:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:38246 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab1DNRqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Daniel T Chen <crimsun@ubuntu.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 062/209] ALSA: hda: Use "alienware" model quirk for another SSID
Date: Thu, 14 Apr 2011 13:41:32 -0400
Message-Id: <1302803039-9400-63-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel T Chen <crimsun@ubuntu.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 0defe09ca70daccdc83abd9c3c24cd89ae6a1141 upstream.

BugLink: https://launchpad.net/bugs/683695

The original reporter states that headphone jacks do not appear to
work.  Upon inspecting his codec dump, and upon further testing, it is
confirmed that the "alienware" model quirk is correct.

Reported-and-tested-by: Cody Thierauf
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_sigmatel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index f1e7bab..6cf2dd4 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1616,6 +1616,8 @@ static struct snd_pci_quirk stac92hd73xx_cfg_tbl[] = {
 static struct snd_pci_quirk stac92hd73xx_codec_id_cfg_tbl[] = {
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02a1,
 		      "Alienware M17x", STAC_ALIENWARE_M17X),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x043a,
+		      "Alienware M17x", STAC_ALIENWARE_M17X),
 	{} /* terminator */
 };
 
-- 
1.7.4.4

