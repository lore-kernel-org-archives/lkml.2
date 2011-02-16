Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab1BPBuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:50:00 -0500
Received: from kroah.org ([198.145.64.141]:48858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218Ab1BPBty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:58 2011
Message-Id: <20110216014658.229784969@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [039/115] [media] em28xx: Fix audio input for Terratec Grabby
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit a3fa904ec79b94f0db7faed010ff94d42f7d1d47 upstream.

The audio input line was wrong. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/em28xx/em28xx-cards.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1525,11 +1525,11 @@ struct em28xx_board em28xx_boards[] = {
 		.input           = { {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = SAA7115_COMPOSITE0,
-			.amux     = EM28XX_AMUX_VIDEO2,
+			.amux     = EM28XX_AMUX_LINE_IN,
 		}, {
 			.type     = EM28XX_VMUX_SVIDEO,
 			.vmux     = SAA7115_SVIDEO3,
-			.amux     = EM28XX_AMUX_VIDEO2,
+			.amux     = EM28XX_AMUX_LINE_IN,
 		} },
 	},
 	[EM2860_BOARD_TERRATEC_AV350] = {


