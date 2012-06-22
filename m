Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756Ab2FVXQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:16:08 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:25283 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2FVXQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:16:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1340406966!12242929!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/31] staging: comedi: ni_daq_700: cleanup to the pcmcia_driver declaration
Date: Fri, 22 Jun 2012 16:16:00 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221616.00890.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, add some whitespace to the declaration
of the pcmcia_driver and reorder it a bit.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index af4f10f..30eeb9d 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -430,13 +430,13 @@ static const struct pcmcia_device_id dio700_cs_ids[] = {
 MODULE_DEVICE_TABLE(pcmcia, dio700_cs_ids);
 
 static struct pcmcia_driver dio700_cs_driver = {
-	.probe = dio700_cs_attach,
-	.remove = dio700_cs_detach,
-	.suspend = dio700_cs_suspend,
-	.resume = dio700_cs_resume,
-	.id_table = dio700_cs_ids,
-	.owner = THIS_MODULE,
-	.name = "ni_daq_700",
+	.name		= "ni_daq_700",
+	.owner		= THIS_MODULE,
+	.probe		= dio700_cs_attach,
+	.remove		= dio700_cs_detach,
+	.suspend	= dio700_cs_suspend,
+	.resume		= dio700_cs_resume,
+	.id_table	= dio700_cs_ids,
 };
 
 static int __init dio700_cs_init(void)
-- 
1.7.11

