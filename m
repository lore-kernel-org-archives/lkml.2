Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1FOAHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:07:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41043 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab1FOAHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:07:03 -0400
Date: Tue, 14 Jun 2011 17:06:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Subject: [PATCH 2/2] gpio: include linux/gpio.h where needed
Message-Id: <20110614170602.7a51b1af.randy.dunlap@oracle.com>
In-Reply-To: <20110614161357.GB1839@ponder.secretlab.ca>
References: <4DDB3AFF.9030006@oracle.com>
	<20110524075248.GB19734@sirena.org.uk>
	<20110527074552.GA907@ponder.secretlab.ca>
	<4DDFE391.2030507@oracle.com>
	<20110527201201.GA6645@ponder.secretlab.ca>
	<BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>
	<20110603171837.GA9918@opensource.wolfsonmicro.com>
	<BANLkTi=oko_C8_46Y8p5O1Qvw1KEn-1PjA@mail.gmail.com>
	<4DEC4D67.6010506@oracle.com>
	<20110614091211.465553de.randy.dunlap@oracle.com>
	<20110614161357.GB1839@ponder.secretlab.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4DF7F796.001C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Some files use GPIOF_ macros but don't include the header file
for them.  These macros are being moved to <linux/gpio.h>, so add
includes for <linux/gpio.h> where needed.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/arm/mach-pxa/spitz_pm.c    |    1 +
 drivers/pcmcia/pxa2xx_vpac270.c |    1 +
 2 files changed, 2 insertions(+)

--- linux-next-20110614.orig/arch/arm/mach-pxa/spitz_pm.c
+++ linux-next-20110614/arch/arm/mach-pxa/spitz_pm.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
+#include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/apm-emulation.h>
--- linux-next-20110614.orig/drivers/pcmcia/pxa2xx_vpac270.c
+++ linux-next-20110614/drivers/pcmcia/pxa2xx_vpac270.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/gpio.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
