Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0EXAIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 20:08:15 -0400
Received: from xenotime.net ([72.52.115.56]:42403 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754807Ab0EXAIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 20:08:04 -0400
Date: Sun, 23 May 2010 17:02:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 1/9] docbook: make mtd nand module init static
Message-ID: <12746593501290@xenotime.net>
In-Reply-To: 
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hsweeten@visionengravers.com>

In the example the module_init function should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 Documentation/DocBook/mtdnand.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2634-docs.orig/Documentation/DocBook/mtdnand.tmpl
+++ lnx-2634-docs/Documentation/DocBook/mtdnand.tmpl
@@ -269,7 +269,7 @@ static void board_hwcontrol(struct mtd_i
 			information about the device.
 		</para>
 		<programlisting>
-int __init board_init (void)
+static int __init board_init (void)
 {
 	struct nand_chip *this;
 	int err = 0;


-- 

