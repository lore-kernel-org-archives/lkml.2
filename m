Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0GLUpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:45:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab0GLUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:45:18 -0400
Message-ID: <4C3B7EFD.1070605@infradead.org>
Date: Mon, 12 Jul 2010 17:45:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Lightning/1.0b2 Thunderbird/3.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: fix EDAC-I7CORE file patterns
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

File patterns are one per line.
Fixed include file location.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
---

 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-edac-i7core-file-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-edac-i7core-file-patterns
+++ a/MAINTAINERS
@@ -2132,7 +2132,9 @@ M:	Mauro Carvalho Chehab <mchehab@redhat
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
-F:	drivers/edac/i7core_edac.c linux/edac_mce.h drivers/edac/edac_mce.c
+F:	drivers/edac/i7core_edac.c
+F:	drivers/edac/edac_mce.c
+F:	include/linux/edac_mce.h
 
 EDAC-I82975X
 M:	Ranganathan Desikan <ravi@jetztechnologies.com>

