Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab2FYWRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:17:25 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:64695 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2FYWRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:17:24 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-131.messagelabs.com!1340662643!13570505!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/33] staging: comedi: cb_das16_cs: move the MODULE_* stuff to the EOF
Date: Mon, 25 Jun 2012 15:17:20 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251517.20487.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the MODULE_* declarations to the end of the file.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 1fd4460..76833d0 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -769,9 +769,6 @@ static const struct pcmcia_device_id das16cs_id_table[] = {
 };
 
 MODULE_DEVICE_TABLE(pcmcia, das16cs_id_table);
-MODULE_AUTHOR("David A. Schleef <ds@schleef.org>");
-MODULE_DESCRIPTION("Comedi driver for Computer Boards PC-CARD DAS16/16");
-MODULE_LICENSE("GPL");
 
 struct pcmcia_driver das16cs_driver = {
 	.probe = das16cs_pcmcia_attach,
@@ -811,3 +808,7 @@ void __exit cleanup_module(void)
 	exit_das16cs_pcmcia_cs();
 	comedi_driver_unregister(&driver_das16cs);
 }
+
+MODULE_AUTHOR("David A. Schleef <ds@schleef.org>");
+MODULE_DESCRIPTION("Comedi driver for Computer Boards PC-CARD DAS16/16");
+MODULE_LICENSE("GPL");
-- 
1.7.11

