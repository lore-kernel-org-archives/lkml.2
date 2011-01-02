Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1ABHqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:46:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:36189 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab1ABHYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:14 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Luke Yelavich <luke.yelavich@canonical.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 162/260] ALSA: hda - Add Dell Latitude E6400 model quirk
Date: Sun,  2 Jan 2011 02:17:38 -0500
Message-Id: <1293952756-15010-163-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:08.0025 (UTC) FILETIME=[E7512690:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luke Yelavich <luke.yelavich@canonical.com>

commit 0f9f1ee9d1412d45a22bfd69dfd4d4324b506e9e upstream.

BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/643891

Set the Dell Latitude E6400 (1028:0233) SSID to use AD1984_DELL_DESKTOP

Signed-off-by: Luke Yelavich <luke.yelavich@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/patch_analog.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index e9fdfc4..ca61b88 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3629,6 +3629,7 @@ static struct snd_pci_quirk ad1984_cfg_tbl[] = {
 	/* Lenovo Thinkpad T61/X61 */
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Lenovo Thinkpad", AD1984_THINKPAD),
 	SND_PCI_QUIRK(0x1028, 0x0214, "Dell T3400", AD1984_DELL_DESKTOP),
+	SND_PCI_QUIRK(0x1028, 0x0233, "Dell Latitude E6400", AD1984_DELL_DESKTOP),
 	{}
 };
 
-- 
1.7.3.3

