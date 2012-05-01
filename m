Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab2EAGZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:25:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53700 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2EAGZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:25:38 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 2/5] Staging: comedi: fix printk issue in pcmmio.c
Date: Tue,  1 May 2012 11:55:07 +0530
Message-Id: <1335853510-29545-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335853510-29545-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1335853510-29545-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the pcmmio.c file that fixes up a printk warning
found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/pcmmio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index eddac00..319883d 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -667,7 +667,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 		}
 #ifdef DAMMIT_ITS_BROKEN
 		/* DEBUG */
-		printk("data_out_byte %02x\n", (unsigned)byte);
+		printk(KERN_DEBUG "data_out_byte %02x\n", (unsigned)byte);
 #endif
 		/* save the digital input lines for this byte.. */
 		s->state |= ((unsigned int)byte) << offset;
-- 
1.7.0.4

