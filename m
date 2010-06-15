Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab0FOUjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:39:08 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3024 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758317Ab0FOUjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:39:06 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "JD (Jiandong) Zheng" <jdzheng@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "JD (Jiandong) Zheng" <jdzheng@broadcom.com>
Date: Tue, 15 Jun 2010 13:38:43 -0700
Subject: [PATCH] MAINTAINERS: Change BCMRING maintainer
Thread-Topic: [PATCH] MAINTAINERS: Change BCMRING maintainer
Thread-Index: AcsIJo2rJxkbVPTmTEyxVryHWefkmwEo5/GA
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADDDC694E3F3@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 60093B5F20S158722142-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am Jiandong Zheng working on BCMRING in Broadcom Canada Ltd. I am replacing Leo Chen (leochen@broadcom.com) as " ARM/BCMRING ARM ARCHITECTURE" and "ARM/BCMRING MTD NAND DRIVER" maintainer.

Here is the patch to MAINTAINERS file in linux 2.6.34 about this change.

Signed-off-by: Jiandong Zheng <jdzheng@broadcom.com>

diff -urN linux-2.6.34/MAINTAINERS.orig linux-2.6.34/MAINTAINERS
--- linux-2.6.34/MAINTAINERS.orig	2010-06-15 11:59:53.202128994 -0700
+++ linux-2.6.34/MAINTAINERS	2010-06-15 12:01:59.862277620 -0700
@@ -570,14 +570,14 @@
 S:	Maintained
 
 ARM/BCMRING ARM ARCHITECTURE
-M:	Leo Chen <leochen@broadcom.com>
+M:	Jiandong Zheng <jdzheng@broadcom.com>
 M:	Scott Branden <sbranden@broadcom.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/mach-bcmring
 
 ARM/BCMRING MTD NAND DRIVER
-M:	Leo Chen <leochen@broadcom.com>
+M:	Jiandong Zheng <jdzheng@broadcom.com>
 M:	Scott Branden <sbranden@broadcom.com>
 L:	linux-mtd@lists.infradead.org
 S:	Maintained


Thanks,

Jiandong Zheng
Senior Staff Software Engineer
Broadcom Canada Ltd.

