Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3AIADH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:03:07 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53584 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab3AHXhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:06 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Bankim Bhavsar <bbhavsar@vmware.com>, Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 07/77] ALSA: hda - Add support for VMware controller
Date: Tue, 8 Jan 2013 18:34:46 -0500
Message-ID: <1357688156-25387-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bankim Bhavsar <bbhavsar@vmware.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0f0714c5ed0a98fdeaa2287d3b159989bbe6d842 upstream.

Add the new PCI ID 0x15ad and device ID 0x1977 for VMware HDAudio
Controller.

[changed to use AZX_DRIVER_GENERIC by tiwai]

Signed-off-by: Bankim Bhavsar <bbhavsar@vmware.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/hda_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index d003298..a1a1e82 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2782,6 +2782,8 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
 #endif
 	/* Vortex86MX */
 	{ PCI_DEVICE(0x17f3, 0x3010), .driver_data = AZX_DRIVER_GENERIC },
+	/* VMware HDAudio */
+	{ PCI_DEVICE(0x15ad, 0x1977), .driver_data = AZX_DRIVER_GENERIC },
 	/* AMD/ATI Generic, PCI class code and Vendor ID for HD Audio */
 	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_ANY_ID),
 	  .class = PCI_CLASS_MULTIMEDIA_HD_AUDIO << 8,
-- 
1.7.12.1

