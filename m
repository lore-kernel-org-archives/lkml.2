Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab2ATUhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:37:07 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40083 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756340Ab2ATUhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:37:03 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 4/5] MAINTAINERS: Update lguest F: patterns
Date: Fri, 20 Jan 2012 12:36:20 -0800
Message-Id: <a0463d6e1d04e0d802d9eea366d12e3645a6f278.1327091633.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1327091633.git.joe@perches.com>
References: <cover.1327091633.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 07fe9977b623 ("lguest: move the lguest tool to the tools directory")
moved the files, update the patterns.  Sort F: patterns alphabetically too.

cc: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b99e4a..ff21f0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3972,11 +3972,11 @@ M:	Rusty Russell <rusty@rustcorp.com.au>
 L:	lguest@lists.ozlabs.org
 W:	http://lguest.ozlabs.org/
 S:	Odd Fixes
-F:	Documentation/virtual/lguest/
+F:	arch/x86/include/asm/lguest*.h
 F:	arch/x86/lguest/
 F:	drivers/lguest/
 F:	include/linux/lguest*.h
-F:	arch/x86/include/asm/lguest*.h
+F:	tools/lguest/
 
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
-- 
1.7.8.111.gad25c.dirty

