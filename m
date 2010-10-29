Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007Ab0J2VD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 17:03:59 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57887 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab0J2VD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 17:03:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.37-rc - drivers/dma/Kconfig - add part number for Topcliff.
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 29 Oct 2010 17:03:46 -0400
Message-ID: <23696.1288386226@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4CCB36B3.005A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Product codenames are OK, but once an actual product name is available, it
should be referenced as well.

http://ark.intel.com/chipset.aspx?familyID=52499

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

---
--- drivers/dma/Kconfig.dist	2010-10-29 16:51:21.171313506 -0400
+++ drivers/dma/Kconfig	2010-10-29 16:53:01.174474799 -0400
@@ -200,11 +200,11 @@ config PL330_DMA
 	  platform_data for a dma-pl330 device.
 
 config PCH_DMA
-	tristate "Topcliff PCH DMA support"
+	tristate "Topcliff (Intel EG20T) PCH DMA support"
 	depends on PCI && X86
 	select DMA_ENGINE
 	help
-	  Enable support for the Topcliff PCH DMA engine.
+	  Enable support for the Topcliff (Intel EG20T) PCH DMA engine.
 
 config IMX_SDMA
 	tristate "i.MX SDMA support"

