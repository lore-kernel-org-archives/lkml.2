Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244Ab2FVXQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:16:50 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:26169 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2FVXQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:16:48 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1340407007!4880258!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/31] staging: comedi: ni_daq_700: remove some useless comments
Date: Fri, 22 Jun 2012 16:16:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221616.41849.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some useless comments and whitespace.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 30eeb9d..1059297 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -111,8 +111,6 @@ static struct comedi_driver driver_dio700 = {
 	.offset = sizeof(struct dio700_board),
 };
 
-/*	the real driver routines	*/
-
 #define _700_SIZE 8
 
 #define _700_DATA 0
@@ -342,7 +340,7 @@ static int dio700_cs_attach(struct pcmcia_device *link)
 	dio700_config(link);
 
 	return 0;
-}				/* dio700_cs_attach */
+}
 
 static void dio700_cs_detach(struct pcmcia_device *link)
 {
@@ -392,14 +390,14 @@ failed:
 	printk(KERN_INFO "ni_daq_700 cs failed");
 	dio700_release(link);
 
-}				/* dio700_config */
+}
 
 static void dio700_release(struct pcmcia_device *link)
 {
 	dev_dbg(&link->dev, "dio700_release\n");
 
 	pcmcia_disable_device(link);
-}				/* dio700_release */
+}
 
 static int dio700_cs_suspend(struct pcmcia_device *link)
 {
@@ -408,7 +406,7 @@ static int dio700_cs_suspend(struct pcmcia_device *link)
 	/* Mark the device as stopped, to block IO until later */
 	local->stop = 1;
 	return 0;
-}				/* dio700_cs_suspend */
+}
 
 static int dio700_cs_resume(struct pcmcia_device *link)
 {
@@ -416,17 +414,12 @@ static int dio700_cs_resume(struct pcmcia_device *link)
 
 	local->stop = 0;
 	return 0;
-}				/* dio700_cs_resume */
-
-/*====================================================================*/
+}
 
 static const struct pcmcia_device_id dio700_cs_ids[] = {
-	/* N.B. These IDs should match those in dio700_boards */
-	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x4743),	/* daqcard-700 */
+	PCMCIA_DEVICE_MANF_CARD(0x010b, 0x4743),
 	PCMCIA_DEVICE_NULL
 };
-
-
 MODULE_DEVICE_TABLE(pcmcia, dio700_cs_ids);
 
 static struct pcmcia_driver dio700_cs_driver = {
-- 
1.7.11

