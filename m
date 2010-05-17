Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab0EQX3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:29:08 -0400
Received: from xenotime.net ([72.52.115.56]:38906 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755721Ab0EQX3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:29:01 -0400
Date: Mon, 17 May 2010 16:21:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH 1/10] docbook: make mtd nand module init static
Message-ID: <12741384713102@xenotime.net>
In-Reply-To: <12741384711166@xenotime.net>
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

