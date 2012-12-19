Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2LSQpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:45:24 -0500
Received: from mx2.parallels.com ([64.131.90.16]:45328 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab2LSQpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:45:13 -0500
From: Alexander Kartashov <alekskartashov@parallels.com>
To: Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <gorcunov@openvz.org>, <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Kartashov <alekskartashov@parallels.com>
Subject: [PATCH 1/3] kcmp: Include linux/ptrace.h
Date: Wed, 19 Dec 2012 20:44:28 +0400
Message-ID: <1355935470-21001-2-git-send-email-alekskartashov@parallels.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355935470-21001-1-git-send-email-alekskartashov@parallels.com>
References: <20689.54803.684081.31731@pilspetsen.it.uu.se>
 <1355935470-21001-1-git-send-email-alekskartashov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

This makes it compile on s390. After all the ptrace_may_access
(which we use this file) is declared exactly in linux/ptrace.h.

This is preparatory work to wire this syscall up on all archs.

Original-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Eric W. Biederman <ebiederm@xmission.com>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Alexander Kartashov <alekskartashov@parallels.com>
Signed-off-by: Alexander Kartashov <alekskartashov@parallels.com>
---
 kernel/kcmp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/kcmp.c b/kernel/kcmp.c
index 30b7b22..e30ac0f 100644
--- a/kernel/kcmp.c
+++ b/kernel/kcmp.c
@@ -4,6 +4,7 @@
 #include <linux/string.h>
 #include <linux/random.h>
 #include <linux/module.h>
+#include <linux/ptrace.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/cache.h>
-- 
1.7.9.5

