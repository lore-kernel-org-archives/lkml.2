Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0LDAoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:44:11 -0500
Received: from adelie.canonical.com ([91.189.90.139]:46499 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab0LDAoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:44:08 -0500
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] Enable jack sense for Thinkpad Edge 13
Date: Fri,  3 Dec 2010 18:43:55 -0600
Message-Id: <1291423435-29261-2-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291423435-29261-1-git-send-email-manoj.iyer@canonical.com>
References: <1291423435-29261-1-git-send-email-manoj.iyer@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a quirk to cxt5066_cfg_tbl to enable jack sense for ThinkPad Edge 13.

Reference: http://launchpad.net/bugs/685015

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 sound/pci/hda/patch_conexant.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 846d1ea..d8b5d48 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3109,6 +3109,7 @@ static struct snd_pci_quirk cxt5066_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT5066_OLPC_XO_1_5),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400s", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21b2, "Thinkpad X100e", CXT5066_IDEAPAD),
+	SND_PCI_QUIRK(0x17aa, 0x21c5, "Thinkpad Edge 13", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21b3, "Thinkpad Edge 13 (197)", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21b4, "Thinkpad Edge", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21c8, "Thinkpad Edge 11", CXT5066_IDEAPAD),
-- 
1.7.1

