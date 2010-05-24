Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab0EXXYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:24:10 -0400
Received: from kroah.org ([198.145.64.141]:59481 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932630Ab0EXXXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:51 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:16 2010
Message-Id: <20100524231815.976531072@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>,
       AmenophisIII <AmenophisIII@gmx.at>, Takashi Iwai <tiwai@suse.de>
Subject: [31/39] ALSA: hda - New Intel HDA controller
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>

commit c602c8ad45d6ee6ad91fc544513cc96f70790983 upstream.

Added a PCI controller id on new Dell laptops.

Signed-off-by: Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>
Cc: AmenophisIII <AmenophisIII@gmx.at>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2718,6 +2718,7 @@ static struct pci_device_id azx_ids[] =
 	{ PCI_DEVICE(0x8086, 0x3a6e), .driver_data = AZX_DRIVER_ICH },
 	/* PCH */
 	{ PCI_DEVICE(0x8086, 0x3b56), .driver_data = AZX_DRIVER_ICH },
+	{ PCI_DEVICE(0x8086, 0x3b57), .driver_data = AZX_DRIVER_ICH },
 	/* CPT */
 	{ PCI_DEVICE(0x8086, 0x1c20), .driver_data = AZX_DRIVER_PCH },
 	/* SCH */


