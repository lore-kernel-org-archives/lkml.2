Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0CVTSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:18:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:36526 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab0CVTSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:30 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 8/8] MAINTAINERS: update kgdb, and debug_core info
Date: Mon, 22 Mar 2010 14:17:29 -0500
Message-Id: <1269285449-1424-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1269285449-1424-8-git-send-email-jason.wessel@windriver.com>
References: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-2-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-3-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-4-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-5-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-6-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-7-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-8-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Mar 2010 19:17:42.0252 (UTC) FILETIME=[583482C0:01CAC9F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the kgdb section.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 MAINTAINERS |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 449d444..2468613 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3269,15 +3269,16 @@ S:	Maintained
 F:	include/linux/kexec.h
 F:	kernel/kexec.c
 
-KGDB
+KGDB / debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
+W:	http://kgdb.wiki.kernel.org/
 L:	kgdb-bugreport@lists.sourceforge.net
 S:	Maintained
 F:	Documentation/DocBook/kgdb.tmpl
 F:	drivers/misc/kgdbts.c
 F:	drivers/serial/kgdboc.c
 F:	include/linux/kgdb.h
-F:	kernel/kgdb.c
+F:	kernel/debug/
 
 KMEMCHECK
 M:	Vegard Nossum <vegardno@ifi.uio.no>
-- 
1.6.4.rc1

