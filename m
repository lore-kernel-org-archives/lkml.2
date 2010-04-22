Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab0DVTmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:42:46 -0400
Received: from kroah.org ([198.145.64.141]:41274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab0DVT3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:23 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:20 2010
Message-Id: <20100422190920.019675812@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Seth Heasley <seth.heasley@intel.com>, Takashi Iwai <tiwai@suse.de>,
       maximilian attems <max@stro.at>
Subject: [142/197] ALSA: hda_intel: ALSA HD Audio patch for Intel Cougar Point DeviceIDs
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit d2f2fcd2541bae004db7f4798ffd9d2cb75ae817 upstream.

This patch adds the Intel Cougar Point (PCH) HD Audio Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -116,6 +116,7 @@ MODULE_SUPPORTED_DEVICE("{{Intel, ICH6},
 			 "{Intel, ICH9},"
 			 "{Intel, ICH10},"
 			 "{Intel, PCH},"
+			 "{Intel, CPT},"
 			 "{Intel, SCH},"
 			 "{ATI, SB450},"
 			 "{ATI, SB600},"
@@ -2666,6 +2667,8 @@ static struct pci_device_id azx_ids[] =
 	{ PCI_DEVICE(0x8086, 0x3a6e), .driver_data = AZX_DRIVER_ICH },
 	/* PCH */
 	{ PCI_DEVICE(0x8086, 0x3b56), .driver_data = AZX_DRIVER_ICH },
+	/* CPT */
+	{ PCI_DEVICE(0x8086, 0x1c20), .driver_data = AZX_DRIVER_ICH },
 	/* SCH */
 	{ PCI_DEVICE(0x8086, 0x811b), .driver_data = AZX_DRIVER_SCH },
 	/* ATI SB 450/600 */


