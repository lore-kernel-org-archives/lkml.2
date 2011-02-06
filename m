Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1BFXpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:45:55 -0500
Received: from 1wt.eu ([62.212.114.60]:60295 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab1BFXpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:45:53 -0500
Message-Id: <20110206232252.659820114@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:22:55 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 03/23] ALSA: hda: Use LPIB quirk for Dell Inspiron m101z/1120
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit e03fa055bc126e536c7f65862e08a9b143138ea9 upstream.

Sjoerd Simons reports that, without using position_fix=1, recording
experiences overruns. Work around that by applying the LPIB quirk
for his hardware.

Reported-and-tested-by: Sjoerd Simons <sjoerd@debian.org>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

Index: longterm-2.6.27/sound/pci/hda/hda_intel.c
===================================================================
--- longterm-2.6.27.orig/sound/pci/hda/hda_intel.c	2011-01-29 15:57:30.000000000 +0100
+++ longterm-2.6.27/sound/pci/hda/hda_intel.c	2011-01-29 15:58:13.711064993 +0100
@@ -1967,6 +1967,7 @@
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1028, 0x0470, "Dell Inspiron 1120", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
 	{}
 };


