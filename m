Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab1JRHsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:48:45 -0400
Received: from mail.danysek.cz ([91.103.163.139]:53713 "EHLO mail.danysek.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab1JRHso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:48:44 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Oct 2011 03:48:44 EDT
Message-ID: <4E9D2DCA.4010603@danysek.cz>
Date: Tue, 18 Oct 2011 09:42:02 +0200
From: Daniel Suchy <danny@danysek.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Icedove/5.0
MIME-Version: 1.0
To: tiwai@suse.de, linux-kernel@vger.kernel.org
Subject: ALSA: HDA: conexant support for Lenovo T520/W520
OpenPGP: id=A2A35A82
Content-Type: multipart/mixed;
 boundary="------------070500070705000301060404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070500070705000301060404
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This is patch for Conexant codec of Intel HDA driver, adding new quirk
for Lenovo Thinkpad T520 and W520. Conexant autodetection works fine for
T520 (similar subsystem ID is used also in W520 model) and detects more
mixer features compared to generic (fallback) Lenovo quirk with
hardcoded options in Conexant codec.

Patch was activelly tested with Linux 3.0.4, 3.0.6 and 3.0.7 without any
problems.

Signed-off-by: Daniel Suchy <danny@danysek.cz>


--------------070500070705000301060404
Content-Type: text/x-diff;
 name="lenovo-thinkpad-t520_conexant.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lenovo-thinkpad-t520_conexant.patch"

--- sound/pci/hda/patch_conexant.c.orig	2011-10-18 09:11:58.000000000 +0200
+++ sound/pci/hda/patch_conexant.c	2011-10-18 09:20:52.072261476 +0200
@@ -3097,6 +3097,7 @@
 	SND_PCI_QUIRK(0x17aa, 0x21c5, "Thinkpad Edge 13", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21c6, "Thinkpad Edge 13", CXT5066_ASUS),
  	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
+	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520 & W520", CXT5066_AUTO),
 	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x21db, "Lenovo X220-tablet", CXT5066_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo U350", CXT5066_ASUS),

--------------070500070705000301060404--
