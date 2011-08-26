Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1H0O6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:58:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab1H0O6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:58:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:54 2011
Message-Id: <20110826215054.627670627@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [17/35] ALSA: ac97: Add HP Compaq dc5100 SFF(PT003AW) to Headphone Jack Sense whitelist
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit eade7b281c9fc18401b989c77d5e5e660b25a3b7 upstream.

BugLink: https://bugs.launchpad.net/bugs/826081

The original reporter needs 'Headphone Jack Sense' enabled to have
audible audio, so add his PCI SSID to the whitelist.

Reported-and-tested-by: Muhammad Khurram Khan
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ac97/ac97_patch.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -1909,6 +1909,7 @@ static unsigned int ad1981_jacks_whiteli
 	0x103c0944, /* HP nc6220 */
 	0x103c0934, /* HP nc8220 */
 	0x103c006d, /* HP nx9105 */
+	0x103c300d, /* HP Compaq dc5100 SFF(PT003AW) */
 	0x17340088, /* FSC Scenic-W */
 	0 /* end */
 };


