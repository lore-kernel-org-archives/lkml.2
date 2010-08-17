Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0HQQjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:39:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26077 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab0HQQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:39:51 -0400
Date: Tue, 17 Aug 2010 09:38:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] mantis: depends on IR_CORE
Message-Id: <20100817093820.f3280d9a.randy.dunlap@oracle.com>
In-Reply-To: <20100817133207.9707400c.sfr@canb.auug.org.au>
References: <20100817133207.9707400c.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

mantis uses ir_input_register so it should depend on IR_CORE.

ERROR: "ir_input_unregister" [drivers/media/dvb/mantis/mantis_core.ko] undefined!
ERROR: "__ir_input_register" [drivers/media/dvb/mantis/mantis_core.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/dvb/mantis/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100817.orig/drivers/media/dvb/mantis/Kconfig
+++ linux-next-20100817/drivers/media/dvb/mantis/Kconfig
@@ -1,6 +1,6 @@
 config MANTIS_CORE
 	tristate "Mantis/Hopper PCI bridge based devices"
-	depends on PCI && I2C && INPUT
+	depends on PCI && I2C && INPUT && IR_CORE
 
 	help
 	  Support for PCI cards based on the Mantis and Hopper PCi bridge.
