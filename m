Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0GFBDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 21:03:14 -0400
Received: from mail.perches.com ([173.55.12.10]:1432 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0GFBDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 21:03:12 -0400
Subject: [PATCH] MAINTAINERS: Fix EDAC-I7CORE file patterns
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 18:03:08 -0700
Message-ID: <1278378188.4126.106.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File patterns are one per line.
Fixed include file location.

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index a07a49d..5884812 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2121,7 +2121,9 @@ M:	Mauro Carvalho Chehab <mchehab@redhat.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
-F:	drivers/edac/i7core_edac.c linux/edac_mce.h drivers/edac/edac_mce.c
+F:	drivers/edac/i7core_edac.c
+F:	drivers/edac/edac_mce.c
+F:	include/linux/edac_mce.h
 
 EDAC-I82975X
 M:	Ranganathan Desikan <ravi@jetztechnologies.com>


