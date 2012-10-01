Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575Ab2JAXbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:31:55 -0400
Received: from 1wt.eu ([62.212.114.60]:35177 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932654Ab2JAXAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:32 -0400
Message-Id: <20121001225202.994935795@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wang Xingchao <xingchao.wang@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 127/180] ALSA: hda - fix Copyright debug message
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Xingchao <xingchao.wang@intel.com>

commit 088c820b732dbfd515fc66d459d5f5777f79b406 upstream.

As spec said, 1 indicates no copyright is asserted.

Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 sound/pci/hda/hda_proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/hda_proc.c b/sound/pci/hda/hda_proc.c
index 2b3d859..9294d40 100644
--- a/sound/pci/hda/hda_proc.c
+++ b/sound/pci/hda/hda_proc.c
@@ -340,7 +340,7 @@ static void print_digital_conv(struct snd_info_buffer *buffer,
 	if (digi1 & AC_DIG1_EMPHASIS)
 		snd_iprintf(buffer, " Preemphasis");
 	if (digi1 & AC_DIG1_COPYRIGHT)
-		snd_iprintf(buffer, " Copyright");
+		snd_iprintf(buffer, " Non-Copyright");
 	if (digi1 & AC_DIG1_NONAUDIO)
 		snd_iprintf(buffer, " Non-Audio");
 	if (digi1 & AC_DIG1_PROFESSIONAL)
-- 
1.7.2.1.45.g54fbc



