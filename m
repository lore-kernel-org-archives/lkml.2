Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2DCU0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:26:44 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:48770 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753286Ab2DCU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:26:42 -0400
Message-ID: <4F7B5CFB.1@xenotime.net>
Date: Tue, 03 Apr 2012 13:26:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Rob Landley <rob@landley.net>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] MAINTAINERS: change in Documentation/ maintainer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

I'm dropping off as Documentation/ maintainer.
Rob Landley has agreed to take it over.  Thanks, Rob.

I'll still be around reviewing patches and testing.
Stephen, please drop my quilt tree from linux-next.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-34-rc1.orig/MAINTAINERS
+++ lnx-34-rc1/MAINTAINERS
@@ -2322,9 +2322,9 @@ S:	Supported
 F:	drivers/acpi/dock.c
 
 DOCUMENTATION
-M:	Randy Dunlap <rdunlap@xenotime.net>
+M:	Rob Landley <rob@landley.net>
 L:	linux-doc@vger.kernel.org
-T:	quilt http://xenotime.net/kernel-doc-patches/current/
+T:	TBD
 S:	Maintained
 F:	Documentation/
 
