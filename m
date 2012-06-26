Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab2FZAXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:23:50 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:49450 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab2FZAXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:23:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1340670228!6915352!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 33/33] staging: comedi: cb_das16_cs: fix a multi-line comment
Date: Mon, 25 Jun 2012 17:23:44 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251723.45225.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a multi-line comment to follow the kernel CodingStyle.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 791bf11..f82db29 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -352,8 +352,10 @@ static int das16cs_ao_winsn(struct comedi_device *dev,
 			outw(status1 | b | 0x0004, dev->iobase + DAS16CS_MISC1);
 			udelay(1);
 		}
-/*		make high both DAC0CS and DAC1CS to load
-		new data and update analog output*/
+		/*
+		 * Make both DAC0CS and DAC1CS high to load
+		 * the new data and update analog the output
+		 */
 		outw(status1 | 0x9, dev->iobase + DAS16CS_MISC1);
 	}
 
-- 
1.7.11

