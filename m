Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab0ESBk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:40:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:41186 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0ESBkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:14 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 24/25] MAINTAINERS: update kgdb, kdb, and debug_core info
Date: Tue, 18 May 2010 20:39:34 -0500
Message-Id: <1274233175-3675-25-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:40:01.0704 (UTC) FILETIME=[32BADA80:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the maintained files sections.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4c2fbbc..7ecce5d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3284,7 +3284,7 @@ F:	include/linux/key-type.h
 F:	include/keys/
 F:	security/keys/
 
-KGDB / debug_core
+KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 W:	http://kgdb.wiki.kernel.org/
 L:	kgdb-bugreport@lists.sourceforge.net
@@ -3292,6 +3292,7 @@ S:	Maintained
 F:	Documentation/DocBook/kgdb.tmpl
 F:	drivers/misc/kgdbts.c
 F:	drivers/serial/kgdboc.c
+F:	include/linux/kdb.h
 F:	include/linux/kgdb.h
 F:	kernel/debug/
 
-- 
1.6.3.3

