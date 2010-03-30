Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab0C3Xen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:34:43 -0400
Received: from kroah.org ([198.145.64.141]:46467 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab0C3XVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:12 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:30 2010
Message-Id: <20100330224829.470495114@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [105/156] ALSA: ac97: Add Toshiba P500 to ac97 jack sense blacklist
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Chen <seven.steps@gmail.com>

commit 5cd165e7057020884e430941c24454d3df9a799d upstream.

BugLink: https://launchpad.net/bugs/481058

The OR has verified that both 'Headphone Jack Sense' and 'Line Jack Sense'
need to be muted for sound to be audible, so just add the machine's SSID
to the ac97 jack sense blacklist.

Reported-by: Richard Gagne
Tested-by: Richard Gagne
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ac97/ac97_patch.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -1873,6 +1873,7 @@ static unsigned int ad1981_jacks_blackli
 	0x10280160, /* Dell Dimension 2400 */
 	0x104380b0, /* Asus A7V8X-MX */
 	0x11790241, /* Toshiba Satellite A-15 S127 */
+	0x1179ff10, /* Toshiba P500 */
 	0x144dc01a, /* Samsung NP-X20C004/SEG */
 	0 /* end */
 };


