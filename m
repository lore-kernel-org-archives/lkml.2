Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab0DVUeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:34:13 -0400
Received: from aliencamel.com ([69.93.184.242]:57462 "EHLO aliencamel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478Ab0DVUeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:34:05 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2010 16:34:04 EDT
Message-ID: <4BD0A49C.1050200@aliencamel.com>
Date: Thu, 22 Apr 2010 20:33:48 +0100
From: Stewart Robertson <stewart_r@aliencamel.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, wfp5p@virginia.edu,
       Stewart Robertson <stewart_r@aliencamel.com>, mithlesh@linsyssoft.com,
       allison@parrot.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: 1832-Staging-comedi-add-missing-KERN_INFO-in-ni_at_ao.c.patch
Content-Type: multipart/mixed; boundary="------------050000030405050205090308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050000030405050205090308
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

>From d9d326dc344759c63048418507fae13fcedc406f Mon Sep 17 00:00:00 2001
From: Stewart Robertson <stewart_r@aliencamel.com>
Date: Thu, 22 Apr 2010 20:12:48 +0100

Subject: [PATCH] Staging: comedi: add missing KERN_INFO in ni_at_ao.c

This is a patch to the ni_at_ao.c file that adds the missing
KERN_INFO requested by the checkpatch.pl tool.

Signed-off-by: Stewart Robertson <stewart_r@aliencamel.com>

---
 drivers/staging/comedi/drivers/ni_at_ao.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index 3778565..ce60224 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -226,7 +226,7 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		iobase = 0x1c0;
 	ao_unipolar = it->options[3];
 
-	printk("comedi%d: ni_at_ao: 0x%04lx", dev->minor, iobase);
+	printk(KERN_INFO "comedi%d: ni_at_ao: 0x%04lx", dev->minor, iobase);
 
 	if (!request_region(iobase, ATAO_SIZE, "ni_at_ao")) {
 		printk(" I/O port conflict\n");
@@ -283,14 +283,14 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	atao_reset(dev);
 
-	printk("\n");
+	printk(KERN_INFO "\n");
 
 	return 0;
 }
 
 static int atao_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: atao: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: atao: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, ATAO_SIZE);
-- 
1.6.0.4



--------------050000030405050205090308
Content-Type: text/x-patch;
 name="1832-Staging-comedi-add-missing-KERN_INFO-in-ni_at_ao.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="1832-Staging-comedi-add-missing-KERN_INFO-in-ni_at_ao.c.patc";
 filename*1="h"

>From d9d326dc344759c63048418507fae13fcedc406f Mon Sep 17 00:00:00 2001
From: Stewart Robertson <stewart_r@aliencamel.com>
Date: Thu, 22 Apr 2010 20:12:48 +0100

Subject: [PATCH] Staging: comedi: add missing KERN_INFO in ni_at_ao.c

This is a patch to the ni_at_ao.c file that adds the missing
KERN_INFO requested by the checkpatch.pl tool.

Signed-off-by: Stewart Robertson <stewart_r@aliencamel.com>
---
 drivers/staging/comedi/drivers/ni_at_ao.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index 3778565..ce60224 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -226,7 +226,7 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		iobase = 0x1c0;
 	ao_unipolar = it->options[3];
 
-	printk("comedi%d: ni_at_ao: 0x%04lx", dev->minor, iobase);
+	printk(KERN_INFO "comedi%d: ni_at_ao: 0x%04lx", dev->minor, iobase);
 
 	if (!request_region(iobase, ATAO_SIZE, "ni_at_ao")) {
 		printk(" I/O port conflict\n");
@@ -283,14 +283,14 @@ static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	atao_reset(dev);
 
-	printk("\n");
+	printk(KERN_INFO "\n");
 
 	return 0;
 }
 
 static int atao_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: atao: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: atao: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, ATAO_SIZE);
-- 
1.6.0.4


--------------050000030405050205090308--
