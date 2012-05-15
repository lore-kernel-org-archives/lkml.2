Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965604Ab2EOC2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:28:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:49870 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965506Ab2EOCSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 166/179] ALSA: ac97: Add HP Compaq dc5100 SFF(PT003AW) to Headphone Jack Sense whitelist
Date: Mon, 14 May 2012 22:14:22 -0400
Message-ID: <1337048075-6132-167-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel T Chen <crimsun@ubuntu.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit eade7b281c9fc18401b989c77d5e5e660b25a3b7 upstream.

BugLink: https://bugs.launchpad.net/bugs/826081

The original reporter needs 'Headphone Jack Sense' enabled to have
audible audio, so add his PCI SSID to the whitelist.

Reported-and-tested-by: Muhammad Khurram Khan
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/ac97/ac97_patch.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/ac97/ac97_patch.c b/sound/pci/ac97/ac97_patch.c
index e68c98e..f26fc25 100644
--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -1900,6 +1900,7 @@ static unsigned int ad1981_jacks_whitelist[] = {
 	0x103c0944, /* HP nc6220 */
 	0x103c0934, /* HP nc8220 */
 	0x103c006d, /* HP nx9105 */
+	0x103c300d, /* HP Compaq dc5100 SFF(PT003AW) */
 	0x17340088, /* FSC Scenic-W */
 	0 /* end */
 };
-- 
1.7.9.6

