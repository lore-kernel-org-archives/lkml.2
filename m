Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab2ILXha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:37:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab2ILXh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:37:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Wang Xingchao <xingchao.wang@intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 03/85] ALSA: hda - fix Copyright debug message
Date: Wed, 12 Sep 2012 16:35:46 -0700
Message-Id: <20120912233542.097478912@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -412,7 +412,7 @@ static void print_digital_conv(struct sn
 	if (digi1 & AC_DIG1_EMPHASIS)
 		snd_iprintf(buffer, " Preemphasis");
 	if (digi1 & AC_DIG1_COPYRIGHT)
-		snd_iprintf(buffer, " Copyright");
+		snd_iprintf(buffer, " Non-Copyright");
 	if (digi1 & AC_DIG1_NONAUDIO)
 		snd_iprintf(buffer, " Non-Audio");
 	if (digi1 & AC_DIG1_PROFESSIONAL)


