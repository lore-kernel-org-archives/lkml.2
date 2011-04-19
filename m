Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1DSSWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 14:22:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45718 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1DSSWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 14:22:13 -0400
Date: Tue, 19 Apr 2011 11:22:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, Andres Salomon <dilinger@queued.net>
Cc: driverdevel <devel@driverdev.osuosl.org>, gregkh <greg@kroah.com>
Subject: [PATCH -next] staging/olpc: xo_1 needs delay.h
Message-Id: <20110419112202.8611bdc4.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020202.4DADD2CE.0141:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error, needs delay.h:

drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:168: error: implicit declaration of function 'udelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c |    1 +
 1 file changed, 1 insertion(+)

Can we get something in MAINTAINERS for OLPC, please?

--- linux-next-20110419.orig/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
+++ linux-next-20110419/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -11,6 +11,7 @@
  * License as published by the Free Software Foundation.
  */
 #include <linux/cs5535.h>
+#include <linux/delay.h>
 #include <linux/gpio.h>
 #include <asm/olpc.h>
 
