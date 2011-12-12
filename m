Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1LLFVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:21:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1LLFVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:21:06 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 14/29] Staging: comedi: fix brace coding style issue in ni_at_a2150.c
Date: Mon, 12 Dec 2011 10:49:26 +0530
Message-Id: <1323667181-17252-14-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_at_a2150.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 32e675e..c25e44c 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -731,9 +731,8 @@ static int a2150_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	outw(trigger_bits, dev->iobase + TRIGGER_REG);
 
 	/*  start acquisition for soft trigger */
-	if (cmd->start_src == TRIG_NOW) {
+	if (cmd->start_src == TRIG_NOW)
 		outw(0, dev->iobase + FIFO_START_REG);
-	}
 #ifdef A2150_DEBUG
 	ni_dump_regs(dev);
 #endif
@@ -860,11 +859,10 @@ static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
 	case TRIG_ROUND_NEAREST:
 	default:
 		/*  if least upper bound is better approximation */
-		if (lub - *period < *period - glb) {
+		if (lub - *period < *period - glb)
 			*period = lub;
-		} else {
+		else
 			*period = glb;
-		}
 		break;
 	case TRIG_ROUND_UP:
 		*period = lub;
-- 
1.7.0.4

