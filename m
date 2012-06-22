Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab2FVXNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:13:15 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:53795 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2FVXNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:13:13 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1340406790!6227975!11
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/31] staging: comedi: ni_daq_700: move the MODULE_* stuff to the EOF
Date: Fri, 22 Jun 2012 16:13:00 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221613.00578.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the MODULE_* declarations to the end of the file.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index fd1acf0..e75bdd0 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -428,10 +428,6 @@ static const struct pcmcia_device_id dio700_cs_ids[] = {
 
 
 MODULE_DEVICE_TABLE(pcmcia, dio700_cs_ids);
-MODULE_AUTHOR("Fred Brooks <nsaspook@nsaspook.com>");
-MODULE_DESCRIPTION("Comedi driver for National Instruments "
-		   "PCMCIA DAQCard-700 DIO");
-MODULE_LICENSE("GPL");
 
 static struct pcmcia_driver dio700_cs_driver = {
 	.probe = dio700_cs_attach,
@@ -471,3 +467,8 @@ void __exit cleanup_module(void)
 	exit_dio700_cs();
 	comedi_driver_unregister(&driver_dio700);
 }
+
+MODULE_AUTHOR("Fred Brooks <nsaspook@nsaspook.com>");
+MODULE_DESCRIPTION(
+	"Comedi driver for National Instruments PCMCIA DAQCard-700 DIO");
+MODULE_LICENSE("GPL");
-- 
1.7.11

