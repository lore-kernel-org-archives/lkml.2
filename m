Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1GKLR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:17:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42649 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab1GKLRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:17:25 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 13/13] Staging: comedi: fix indentation issue in pcl818.c
Date: Mon, 11 Jul 2011 17:00:00 +0530
Message-Id: <1310383800-17428-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 11/11]Staging: comedi:indentation error issue in pcl818.c>
References: <[PATCH 11/11]Staging: comedi:indentation error issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a ERROR: code indent should use tabs where possible  found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |   36 +++++++++++++++---------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 3ac489d..37dcd7c 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -45,11 +45,11 @@ A word or two about DMA. Driver support DMA operations at two ways:
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA	(0=disable, 1, 3)
     [3] - 0, 10=10MHz clock for 8254
-             1= 1MHz clock for 8254
+	      1 = 1MHz clock for 8254
     [4] - 0,  5=A/D input  -5V.. +5V
-          1, 10=A/D input -10V..+10V
+	   1, 10 = A/D input - 10V..+10V
     [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
+	   1, 10 = D/A output 0-10V(internal reference - 10V)
 	  2    =D/A output unknown (external reference)
 
    Options for PCL-818, PCL-818H:
@@ -57,9 +57,9 @@ A word or two about DMA. Driver support DMA operations at two ways:
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA	(0=disable, 1, 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+	      1 = 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
+	   1, 10 = D/A output 0-10V(internal reference - 10V)
 	  2    =D/A output unknown (external reference)
 
    Options for PCL-818HD, PCL-818HG:
@@ -68,33 +68,33 @@ A word or two about DMA. Driver support DMA operations at two ways:
     [2] - DMA/FIFO  (-1=use FIFO, 0=disable both FIFO and DMA,
                       1=use DMA ch 1, 3=use DMA ch 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+	      1 = 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
-          1, 10=D/A output 0-10V (internal reference -10V)
-   	  2    =D/A output unknown (external reference)
+	   1, 10 = D/A output 0-10V (internal reference - 10V)
+	  2    =D/A output unknown (external reference)
 
    Options for PCL-718:
     [0] - IO Base
     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
     [2] - DMA	(0=disable, 1, 3)
     [3] - 0, 10=10MHz clock for 8254
-              1= 1MHz clock for 8254
+	       1= 1MHz clock for 8254
     [4] -     0=A/D Range is +/-10V
 	      1=             +/-5V
 	      2=             +/-2.5V
 	      3=             +/-1V
 	      4=             +/-0.5V
-	      5=  	     user defined bipolar
+	      5=             user defined bipolar
 	      6=	     0-10V
 	      7=	     0-5V
- 	      8=	     0-2V
+	      8=             0-2V
 	      9=	     0-1V
 	     10=	     user defined unipolar
     [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
-          1, 10=D/A outputs 0-10V (internal reference -10V)
+	   1, 10=D/A outputs 0-10V (internal reference -10V)
 	      2=D/A outputs unknown (external reference)
     [6] - 0, 60=max  60kHz A/D sampling
-          1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
+	  1, 100=max 100kHz A/D sampling (PCL - 718 with Option 001 installed)
 
 */
 
@@ -190,7 +190,7 @@ A word or two about DMA. Driver support DMA operations at two ways:
 #define INT_TYPE_AI1_DMA_RTC 9
 #define INT_TYPE_AI3_DMA_RTC 10
 
-#define RTC_IRQ 	8
+#define RTC_IRQ 8
 #define RTC_IO_EXTENT	0x10
 #endif
 
@@ -242,8 +242,8 @@ static const struct comedi_lrange range_pcl818l_h_ai = { 4, {
 };
 
 static const struct comedi_lrange range718_bipolar1 = { 1, {BIP_RANGE(1),} };
-static const struct comedi_lrange range718_bipolar0_5 =
-    { 1, {BIP_RANGE(0.5),} };
+static const struct comedi_lrange range718_bipolar0_5 = { 1,
+{BIP_RANGE(0.5),} };
 static const struct comedi_lrange range718_unipolar2 = { 1, {UNI_RANGE(2),} };
 static const struct comedi_lrange range718_unipolar1 = { 1, {BIP_RANGE(1),} };
 
@@ -252,8 +252,8 @@ static int pcl818_attach(struct comedi_device *dev,
 static int pcl818_detach(struct comedi_device *dev);
 
 #ifdef unused
-static int RTC_lock = 0;	/* RTC lock */
-static int RTC_timer_lock = 0;	/* RTC int lock */
+static int RTC_lock;	/* RTC lock */
+static int RTC_timer_lock;	/* RTC int lock */
 #endif
 
 struct pcl818_board {
-- 
1.6.5.2

