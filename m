Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267Ab1C3VGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:12919 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228Ab1C3VGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132847"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mchehab@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [43/275] em28xx: Fix audio input for Terratec Grabby
Message-Id: <20110330210438.EEE603E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit a3fa904ec79b94f0db7faed010ff94d42f7d1d47 upstream.

The audio input line was wrong. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/video/em28xx/em28xx-cards.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/media/video/em28xx/em28xx-cards.c
===================================================================
--- linux-2.6.35.y.orig/drivers/media/video/em28xx/em28xx-cards.c	2011-03-29 22:51:52.060391073 -0700
+++ linux-2.6.35.y/drivers/media/video/em28xx/em28xx-cards.c	2011-03-29 23:02:59.085323575 -0700
@@ -1605,11 +1605,11 @@
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
