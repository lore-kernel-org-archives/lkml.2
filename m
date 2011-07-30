Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1G3EQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 00:16:44 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:58112 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750920Ab1G3EPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 00:15:23 -0400
Date: Fri, 29 Jul 2011 21:14:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-i2c@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        khali@linux-fr.org, ben-linux@fluff.org
Subject: [PATCH -next] i2c: i2c-pxa-pci.c needs module.h
Message-Id: <20110729211430.6c4830bd.rdunlap@xenotime.net>
In-Reply-To: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

i2c-pxa-pci.c uses interfaces from linux/module.h, so it should
include that file.  This fixes build errors.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/i2c/busses/i2c-pxa-pci.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110729.orig/drivers/i2c/busses/i2c-pxa-pci.c
+++ linux-next-20110729/drivers/i2c/busses/i2c-pxa-pci.c
@@ -3,6 +3,7 @@
  * It does not support slave mode, the register slightly moved. This PCI
  * device provides three bars, every contains a single I2C controller.
  */
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/i2c/pxa-i2c.h>
