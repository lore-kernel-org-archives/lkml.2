Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2GBWmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:42:50 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:25438 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2GBWmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:42:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1341268966!24182554!3
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/12] staging: comedi: das08_cs: move the MODULE_* stuff to the EOF
Date: Mon, 2 Jul 2012 15:42:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021542.41812.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the MODULE_* declarations to the end of the file.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08_cs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 8bf6ec2..f62e5f8 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -224,10 +224,6 @@ static const struct pcmcia_device_id das08_cs_id_table[] = {
 };
 
 MODULE_DEVICE_TABLE(pcmcia, das08_cs_id_table);
-MODULE_AUTHOR("David A. Schleef <ds@schleef.org>, "
-	      "Frank Mori Hess <fmhess@users.sourceforge.net>");
-MODULE_DESCRIPTION("Comedi driver for ComputerBoards DAS-08 PCMCIA boards");
-MODULE_LICENSE("GPL");
 
 struct pcmcia_driver das08_cs_driver = {
 	.probe = das08_pcmcia_attach,
@@ -270,3 +266,8 @@ static void __exit das08_cs_exit_module(void)
 
 module_init(das08_cs_init_module);
 module_exit(das08_cs_exit_module);
+
+MODULE_AUTHOR("David A. Schleef <ds@schleef.org>, "
+	      "Frank Mori Hess <fmhess@users.sourceforge.net>");
+MODULE_DESCRIPTION("Comedi driver for ComputerBoards DAS-08 PCMCIA boards");
+MODULE_LICENSE("GPL");
-- 
1.7.11

