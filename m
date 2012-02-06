Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2BFRuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:50:10 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:36002 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753574Ab2BFRuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:50:05 -0500
Message-ID: <4F3012C8.7080506@xenotime.net>
Date: Mon, 06 Feb 2012 09:50:00 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] Documentation: update quilt tree location for Documentation
 patches
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Update quilt tree location for Documentation/ patches.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-33-rc2.orig/MAINTAINERS
+++ lnx-33-rc2/MAINTAINERS
@@ -2287,7 +2287,7 @@ F:	drivers/acpi/dock.c
 DOCUMENTATION
 M:	Randy Dunlap <rdunlap@xenotime.net>
 L:	linux-doc@vger.kernel.org
-T:	quilt http://userweb.kernel.org/~rdunlap/kernel-doc-patches/current/
+T:	quilt http://xenotime.net/kernel-doc-patches/current/
 S:	Maintained
 F:	Documentation/
 
