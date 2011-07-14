Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1GNI4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:56:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32823 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab1GNI4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:56:35 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: 
Date: Thu, 14 Jul 2011 14:39:19 +0530
Message-Id: <1310634559-1525-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/3]Staging: comedi:fix line over 80 character issue in daqboard2000.c>
References: <[PATCH 1/3]Staging: comedi:fix line over 80 character issue in daqboard2000.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the daqboard2000.c file that fixes up a  indentation warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
Earlier i made some major mistakes now it's fixed.

 drivers/staging/comedi/drivers/daqboard2000.c |   58 ++++++++++++------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 82be77d..6441771 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -54,7 +54,7 @@ Configuration options:
       available from http://www.plxtech.com/products/io/pci9080 
 
    2. The initialization done so far is:
-        a. program the FPGA (windows code sans a lot of error messages)
+	 a. program the FPGA(windows code sans a lot of error messages)
 	 b.
 
    3. Analog out seems to work OK with DAC's disabled, if DAC's are enabled,
@@ -63,52 +63,52 @@ Configuration options:
       gives me no clues. I'll keep it simple so far.
 
    4. Analog in.
-        Each channel in the scanlist seems to be controlled by four
+	 Each channel in the scanlist seems to be controlled by four
 	control words:
 
-        Word0:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	Word0:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 
-        Word1:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	Word1:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 	   |             |       | | | | |
-           +------+------+       | | | | +-- Digital input (??)
+	   +------+------+       | | | | +-- Digital input (??)
 		  |		 | | | +---- 10 us settling time
 		  |		 | | +------ Suspend acquisition (last to scan)
 		  |		 | +-------- Simultaneous sample and hold
 		  |		 +---------- Signed data format
 		  +------------------------- Correction offset low
 
-        Word2:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-           |     | |     | | | | | |     |
-           +-----+ +--+--+ +++ +++ +--+--+
-              |       |     |   |     +----- Expansion channel
+	Word2:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	   |     | |     | | | | | |     |
+	   +-----+ +--+--+ +++ +++ +--+--+
+	      |       |     |   |     +----- Expansion channel
 	      |       |     |   +----------- Expansion gain
-              |       |     +--------------- Channel (low)
+	      |       |     +--------------- Channel (low)
 	      |       +--------------------- Correction offset high
 	      +----------------------------- Correction gain low
-        Word3:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-           |             | | | |   | | | |
-           +------+------+ | | +-+-+ | | +-- Low bank enable
-                  |        | |   |   | +---- High bank enable
-                  |        | |   |   +------ Hi/low select
+	Word3:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	   |      |      | | | |   | | |
+	   +------+------+ | | +-+-+ | | +-- Low bank enable
+		  |        | |   |   | +---- High bank enable
+		  |	   | |   |   +------ Hi/low select
 		  |    	   | |   +---------- Gain (1,?,2,4,8,16,32,64)
 		  |    	   | +-------------- differential/single ended
 		  |    	   +---------------- Unipolar
 		  +------------------------- Correction gain high
 
    999. The card seems to have an incredible amount of capabilities, but
-        trying to reverse engineer them from the Windows source is beyond my
+	trying to reverse engineer them from the Windows source is beyond my
 	patience.
 
  */
@@ -722,7 +722,7 @@ static int daqboard2000_8255_cb(int dir, int port, int data,
 	}
 /*
   printk("daqboard2000_8255_cb %x %d %d %2.2x -> %2.2x\n",
-        arg, dir, port, data, result);
+	 arg, dir, port, data, result);
 */
 	return result;
 }
-- 
1.6.5.2

