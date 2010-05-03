Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0ECKHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 06:07:20 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:63220 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0ECKHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 06:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Kda3SI/ABv4gEXCMS8P9KSSTia7ay7oi45dzuJLZzImem1ojGw9kOj8fKkCH6UNDSa
         uNW+p52l9zjT/s2XxujvlZs2qS8c1uqRWxmMWWoAb1j0n/l9PGgGFtxxcDXTsc4GEZwo
         GkesAB57z0ExWFaOC2qn+uf0Vs9AY//gVUcFk=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de, mithlesh@linsyssoft.com, wfp5p@virginia.edu,
       andrea.gelmini@gelma.net, penberg@cs.helsinki.fi
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mark <reodge@gmail.com>
Subject: [PATCH] Staging: comedi: Adjusted some long line lengths in drivers.c
Date: Mon,  3 May 2010 18:07:36 +0800
Message-Id: <1272881256-30261-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some long line lengths in drivers.c that checkpatch.pl was
complaining about

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/drivers.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index d7a4509..a8f3d79 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -172,7 +172,8 @@ attached:
 	}
 
 	if (!dev->board_name) {
-		printk(KERN_WARNING "BUG: dev->board_name=<%p>\n", dev->board_name);
+		printk(KERN_WARNING "BUG: dev->board_name=<%p>\n",
+		       dev->board_name);
 		dev->board_name = "BUG";
 	}
 	smp_wmb();
@@ -374,8 +375,9 @@ static int insn_rw_emulate_bits(struct comedi_device *dev,
 	if (insn->insn == INSN_WRITE) {
 		if (!(s->subdev_flags & SDF_WRITABLE))
 			return -EINVAL;
-		new_data[0] = 1 << (chan - base_bitfield_channel);	/* mask */
-		new_data[1] = data[0] ? (1 << (chan - base_bitfield_channel)) : 0;	/* bits */
+		new_data[0] = 1 << (chan - base_bitfield_channel); /* mask */
+		new_data[1] = data[0] ? (1 << (chan - base_bitfield_channel))
+			      : 0; /* bits */
 	}
 
 	ret = s->insn_bits(dev, s, &new_insn, new_data);
-- 
1.7.0.5

