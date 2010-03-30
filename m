Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab0C3X7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:59:33 -0400
Received: from kroah.org ([198.145.64.141]:45480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323Ab0C3XSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:55 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:06 2010
Message-Id: <20100330225705.604510449@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [099/116] ALSA: ac97: Add IBM ThinkPad R40e to Headphone/Line Jack Sense blacklist
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit e1f7f02b45cf33a774d56e505ce1718af9392f5e upstream.

BugLink: https://launchpad.net/bugs/303789

This model needs both 'Headphone Jack Sense' and 'Line Jack Sense'
muted for audible audio, so just add its SSID to the blacklist and
don't enumerate the controls.

Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ac97/ac97_patch.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -1867,6 +1867,7 @@ static unsigned int ad1981_jacks_blackli
 	0x10140523, /* Thinkpad R40 */
 	0x10140534, /* Thinkpad X31 */
 	0x10140537, /* Thinkpad T41p */
+	0x1014053e, /* Thinkpad R40e */
 	0x10140554, /* Thinkpad T42p/R50p */
 	0x10140567, /* Thinkpad T43p 2668-G7U */
 	0x10140581, /* Thinkpad X41-2527 */


