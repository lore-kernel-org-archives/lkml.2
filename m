Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab1FFS6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:58:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36359 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab1FFS6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=t5lySc2t2vbbE0P9QHf1p9VmTKFjnPhZmAH43Q6DiFQh/zGAAXX7Ad1e3v1RWfMt9q
         WBMFxlZGu+dM5GMbkyd2gPURz0BGAWBGsxSv7eP+1XQMAu/35MHC1Umlevb46S05A8b3
         zZvGITwXq83s8R2vw5NUgtjiDxML8WJYKgh/A=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 3/9] kconfig: add missing <stdarg.h> inclusion
Date: Mon,  6 Jun 2011 14:58:25 -0400
Message-Id: <1307386711-8866-4-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header is needed when using va_{start,end,copy}(3) functions family.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/confdata.c |    1 +
 scripts/kconfig/menu.c     |    1 +
 scripts/kconfig/util.c     |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index a9f0ebd..2118f4b 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -7,6 +7,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <stdarg.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 5fdf10d..d64108b 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -3,6 +3,7 @@
  * Released under the terms of the GNU GPL v2.0.
  */
 
+#include <stdarg.h>
 #include <stdlib.h>
 #include <string.h>
 
diff --git a/scripts/kconfig/util.c b/scripts/kconfig/util.c
index 6330cc8..e07d557 100644
--- a/scripts/kconfig/util.c
+++ b/scripts/kconfig/util.c
@@ -5,6 +5,7 @@
  * Released under the terms of the GNU GPL v2.0.
  */
 
+#include <stdarg.h>
 #include <string.h>
 #include "lkc.h"
 
-- 
1.7.3.4.574.g608b.dirty

