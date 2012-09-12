Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab2ILX4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:56:10 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157Ab2ILXm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:42:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Wang Xingchao <xingchao.wang@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 03/46] ALSA: hda - fix Copyright debug message
Date: Wed, 12 Sep 2012 16:38:53 -0700
Message-Id: <20120912233818.024833982@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Xingchao <xingchao.wang@intel.com>

commit 088c820b732dbfd515fc66d459d5f5777f79b406 upstream.

As spec said, 1 indicates no copyright is asserted.

Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_proc.c
+++ b/sound/pci/hda/hda_proc.c
@@ -406,7 +406,7 @@ static void print_digital_conv(struct sn
 	if (digi1 & AC_DIG1_EMPHASIS)
 		snd_iprintf(buffer, " Preemphasis");
 	if (digi1 & AC_DIG1_COPYRIGHT)
-		snd_iprintf(buffer, " Copyright");
+		snd_iprintf(buffer, " Non-Copyright");
 	if (digi1 & AC_DIG1_NONAUDIO)
 		snd_iprintf(buffer, " Non-Audio");
 	if (digi1 & AC_DIG1_PROFESSIONAL)


