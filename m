Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab0LOA2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:28:16 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42719 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759108Ab0LOA2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:28:14 -0500
Date: Tue, 14 Dec 2010 16:26:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Cc: Jeff Dike <jdike@addtoit.com>, akpm <akpm@linux-foundation.org>,
        Greg Lonnon <glonnon@ridgerun.com>
Subject: [PATCH] uml: mmapper_kern needs MODULE_LICENSE
Message-Id: <20101214162635.dd87b0d9.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing MODULE_LICENSE():

WARNING: modpost: missing MODULE_LICENSE() in arch/um/drivers/mmapper_kern.o

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Lonnon <glonnon@ridgerun.com>
---
 arch/um/drivers/mmapper_kern.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101214.orig/arch/um/drivers/mmapper_kern.c
+++ linux-next-20101214/arch/um/drivers/mmapper_kern.c
@@ -137,3 +137,4 @@ module_exit(mmapper_exit);
 
 MODULE_AUTHOR("Greg Lonnon <glonnon@ridgerun.com>");
 MODULE_DESCRIPTION("DSPLinux simulator mmapper driver");
+MODULE_LICENSE("GPL");
