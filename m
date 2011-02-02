Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1BBAop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:31213 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab1BBAon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418236"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: manoj.iyer@canonical.com, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [95/139] ALSA: hda - Enable jack sense for Thinkpad Edge 11
Message-Id: <20110202004453.31E2A3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Manoj Iyer <manoj.iyer@canonical.com>

commit 6027277e77df2d2893d906c42f5c9f9abcb731e0 upstream.

Add a quirk entry for Thinkpad Edge 11 as well as other TP Edge models.

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/sound/pci/hda/patch_conexant.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/hda/patch_conexant.c
+++ linux-2.6.35.y/sound/pci/hda/patch_conexant.c
@@ -3039,6 +3039,7 @@ static struct snd_pci_quirk cxt5066_cfg_
 	SND_PCI_QUIRK(0x17aa, 0x21b2, "Thinkpad X100e", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21b3, "Thinkpad Edge 13 (197)", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21b4, "Thinkpad Edge", CXT5066_IDEAPAD),
+	SND_PCI_QUIRK(0x17aa, 0x21c8, "Thinkpad Edge 11", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "ideapad", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
 	{}
