Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab0JFBBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:01:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab0JFBB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rkq+bnIlHC7hLzxFODkrVv+4M27A7mCikR+isF7taFJmXlUzFzBsfE0rV25JgNaaXF
         BQyuyAs6SAS6M7uyXDFQruS7YuAFuWScWjtz8rI1O7eWnU30ztVVKuejz34YoYA7IylY
         48IsQbqapuiJ1WnXj3SXybd33SpvgPWbbuk1E=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 21/28] Staging: comedi: drivers: adq12b.c: Edit file so that checkpatch.pl has 0 errors and 2 warnings
Date: Tue,  5 Oct 2010 21:00:36 -0400
Message-Id: <1286326843-6170-21-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a lot lines that made checkpatch.pl complain. Most  warnings were
WARNING: please, no space for starting a line. The only remainig warnings are
WARNING: line over 80 characters.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/comedi/drivers/adq12b.c |   88 +++++++++++++++---------------
 1 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index 4b47000..6e5f72f 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -1,23 +1,23 @@
 /*
-    comedi/drivers/adq12b.c
-    driver for MicroAxial ADQ12-B data acquisition and control card
+	comedi/drivers/adq12b.c
+	driver for MicroAxial ADQ12-B data acquisition and control card
 
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 2000 David A. Schleef <ds@schleef.org>
+	COMEDI - Linux Control and Measurement Device Interface
+	Copyright (C) 2000 David A. Schleef <ds@schleef.org>
 
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
 
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
 
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
 */
 /*
@@ -30,50 +30,50 @@ Status: works
 
 Driver for the acquisition card ADQ12-B (without any add-on).
 
- - Analog input is subdevice 0 (16 channels single-ended or 8 differential)
- - Digital input is subdevice 1 (5 channels)
- - Digital output is subdevice 1 (8 channels)
- - The PACER is not supported in this version
+- Analog input is subdevice 0 (16 channels single-ended or 8 differential)
+- Digital input is subdevice 1 (5 channels)
+- Digital output is subdevice 1 (8 channels)
+- The PACER is not supported in this version
 
 If you do not specify any options, they will default to
 
-  # comedi_config /dev/comedi0 adq12b 0x300,0,0
+	# comedi_config /dev/comedi0 adq12b 0x300,0,0
 
-  option 1: I/O base address. The following table is provided as a help
-   of the hardware jumpers.
+	option 1: I/O base address. The following table is provided as a help
+	of the hardware jumpers.
 
-	 address            jumper JADR
-	  0x300                 1 (factory default)
-	  0x320                 2
-	  0x340                 3
-	  0x360                 4
-	  0x380                 5
-	  0x3A0                 6
+	address            jumper JADR
+	 0x300                 1 (factory default)
+	 0x320                 2
+	 0x340                 3
+	 0x360                 4
+	 0x380                 5
+	 0x3A0                 6
 
-  option 2: unipolar/bipolar ADC selection: 0 -> bipolar, 1 -> unipolar
+	option 2: unipolar/bipolar ADC selection: 0 -> bipolar, 1 -> unipolar
 
 	selection         comedi_config option            JUB
 	 bipolar                0                         2-3 (factory default)
 	 unipolar               1                         1-2
 
-  option 3: single-ended/differential AI selection: 0 -> SE, 1 -> differential
+	option 3: single-ended/differential AI selection: 0 -> SE, 1 -> differential
 
 	selection         comedi_config option     JCHA    JCHB
-       single-ended             0                  1-2     1-2 (factory default)
-       differential             1                  2-3     2-3
+	 single-ended             0                  1-2     1-2 (factory default)
+	 differential             1                  2-3     2-3
 
-   written by jeremy theler <thelerg@ib.cnea.gov.ar>
+	written by jeremy theler <thelerg@ib.cnea.gov.ar>
 
-   instituto balseiro
-   comision nacional de energia atomica
-   universidad nacional de cuyo
-   argentina
+	instituto balseiro
+	comision nacional de energia atomica
+	universidad nacional de cuyo
+	argentina
 
-   21-feb-2008
-     + changed supported devices string (missused the [] and ())
+	21-feb-2008
+		+ changed supported devices string (missused the [] and ())
 
-   13-oct-2007
-     + first try
+	13-oct-2007
+		+ first try
 
 
 */
@@ -238,8 +238,8 @@ static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	devpriv->unipolar = unipolar;
 	devpriv->differential = differential;
 	devpriv->digital_state = 0;
-/* initialize channel and range to -1 so we make sure we always write
-   at least once to the CTREG in the instruction */
+/*initialize channel and range to -1 so we make sure we always write
+ *at least once to the CTREG in the instruction */
 	devpriv->last_channel = -1;
 	devpriv->last_range = -1;
 
-- 
1.7.3.1.50.g1e633

