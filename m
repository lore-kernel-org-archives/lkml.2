Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab0EGVt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:49:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49682 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0EGVt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:49:26 -0400
Date: Fri, 7 May 2010 14:47:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, jens.axboe@oracle.com
Subject: [PATCH] paride: fix menu indentation
Message-Id: <20100507144756.fbebdebe.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4BE48ADC.00E3:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make the PARIDE menu be displayed correctly, with proper/expected
indentation, by moving the GDROM kconfig symbol, which was
splitting the PARIDE kconfig symbol from its dependent symbols.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/block/Kconfig |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- linux-2.6.34-rc6-git5.orig/drivers/block/Kconfig
+++ linux-2.6.34-rc6-git5/drivers/block/Kconfig
@@ -76,6 +76,17 @@ config BLK_DEV_XD
 
 	  It's pretty unlikely that you have one of these: say N.
 
+config GDROM
+	tristate "SEGA Dreamcast GD-ROM drive"
+	depends on SH_DREAMCAST
+	help
+	  A standard SEGA Dreamcast comes with a modified CD ROM drive called a
+	  "GD-ROM" by SEGA to signify it is capable of reading special disks
+	  with up to 1 GB of data. This drive will also read standard CD ROM
+	  disks. Select this option to access any disks in your GD ROM drive.
+	  Most users will want to say "Y" here.
+	  You can also build this as a module which will be called gdrom.
+
 config PARIDE
 	tristate "Parallel port IDE device support"
 	depends on PARPORT_PC
@@ -103,17 +114,6 @@ config PARIDE
 	  "MicroSolutions backpack protocol", "DataStor Commuter protocol"
 	  etc.).
 
-config GDROM
-	tristate "SEGA Dreamcast GD-ROM drive"
-	depends on SH_DREAMCAST
-	help
-	  A standard SEGA Dreamcast comes with a modified CD ROM drive called a
-	  "GD-ROM" by SEGA to signify it is capable of reading special disks
-	  with up to 1 GB of data. This drive will also read standard CD ROM
-	  disks. Select this option to access any disks in your GD ROM drive.
-	  Most users will want to say "Y" here.
-	  You can also build this as a module which will be called gdrom.
-
 source "drivers/block/paride/Kconfig"
 
 config BLK_CPQ_DA
