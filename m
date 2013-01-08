Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3AIACM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:02:12 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53587 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab3AHXhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Seth Heasley <seth.heasley@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [v2.6.34-stable 09/77] ALSA: hda - ALSA HD Audio patch for Intel Panther Point DeviceIDs
Date: Tue, 8 Jan 2013 18:34:48 -0500
Message-ID: <1357688156-25387-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Seth Heasley <seth.heasley@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d2edeb7c6f1dada8ca7d5c23e42d604e92ae0c76 upstream.

This patch adds the HD Audio Controller DeviceIDs for the Intel Panther Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/hda/hda_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 144d41d..2a6c825 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -126,6 +126,7 @@ MODULE_SUPPORTED_DEVICE("{{Intel, ICH6},"
 			 "{Intel, ICH10},"
 			 "{Intel, PCH},"
 			 "{Intel, CPT},"
+			 "{Intel, PPT},"
 			 "{Intel, PBG},"
 			 "{Intel, SCH},"
 			 "{ATI, SB450},"
@@ -2720,6 +2721,8 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 	{ PCI_DEVICE(0x8086, 0x1c20), .driver_data = AZX_DRIVER_PCH },
 	/* PBG */
 	{ PCI_DEVICE(0x8086, 0x1d20), .driver_data = AZX_DRIVER_PCH },
+	/* Panther Point */
+	{ PCI_DEVICE(0x8086, 0x1e20), .driver_data = AZX_DRIVER_PCH },
 	/* SCH */
 	{ PCI_DEVICE(0x8086, 0x811b), .driver_data = AZX_DRIVER_SCH },
 	/* Generic Intel */
-- 
1.7.12.1

