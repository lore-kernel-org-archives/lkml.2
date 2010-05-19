Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab0ESBnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:43:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:41209 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0ESBkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:20 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 03/25] MAINTAINERS: update kgdb, and debug_core info
Date: Tue, 18 May 2010 20:39:13 -0500
Message-Id: <1274233175-3675-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:43.0406 (UTC) FILETIME=[27D2CCE0:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the kgdb section.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 MAINTAINERS |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d329b05..4c2fbbc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3284,15 +3284,16 @@ F:	include/linux/key-type.h
 F:	include/keys/
 F:	security/keys/
 
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
1.6.3.3

