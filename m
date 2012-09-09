Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2IIXWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:22:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51529 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756402Ab2IIXRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:14 -0400
Message-Id: <20120909224154.040072998@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wang Xingchao <xingchao.wang@intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 23/95] ALSA: hda - fix Copyright debug message
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Xingchao <xingchao.wang@intel.com>

commit 088c820b732dbfd515fc66d459d5f5777f79b406 upstream.

As spec said, 1 indicates no copyright is asserted.

Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/hda_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_proc.c b/sound/pci/hda/hda_proc.c
index 7e46258..6894ec6 100644
--- a/sound/pci/hda/hda_proc.c
+++ b/sound/pci/hda/hda_proc.c
@@ -412,7 +412,7 @@ static void print_digital_conv(struct snd_info_buffer *buffer,
 	if (digi1 & AC_DIG1_EMPHASIS)
 		snd_iprintf(buffer, " Preemphasis");
 	if (digi1 & AC_DIG1_COPYRIGHT)
-		snd_iprintf(buffer, " Copyright");
+		snd_iprintf(buffer, " Non-Copyright");
 	if (digi1 & AC_DIG1_NONAUDIO)
 		snd_iprintf(buffer, " Non-Audio");
 	if (digi1 & AC_DIG1_PROFESSIONAL)


