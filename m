Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab2FZALW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:11:22 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:20328 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab2FZALU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:11:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1340669479!12491698!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/33] staging: comedi: cb_das16_cs: remove unneeded include
Date: Mon, 25 Jun 2012 17:11:13 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251711.13725.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is not for a pci device. Remove the unneeded include
of the pci.h header.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index acee550..2d8ec68 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -42,7 +42,6 @@ Status: experimental
 #include <linux/slab.h>
 #include "../comedidev.h"
 #include <linux/delay.h>
-#include <linux/pci.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
-- 
1.7.11

