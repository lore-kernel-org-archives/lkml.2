Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab0EXXIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:08:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:55419 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378Ab0EXXIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:08:44 -0400
Date: Mon, 24 May 2010 23:08:24 GMT
From: tip-bot for Peter Huewe <peterhuewe@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, luca@luca-barbieri.com, peterhuewe@gmx.de,
       tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       luca@luca-barbieri.com, akpm@linux-foundation.org, tglx@linutronix.de,
       peterhuewe@gmx.de, hpa@linux.intel.com
In-Reply-To: <201005241913.o4OJDKdf010884@imap1.linux-foundation.org>
References: <201005241913.o4OJDKdf010884@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] lib/atomic64_test: fix missing include of linux/kernel.h
Message-ID: <tip-0dbdd1bfe0b83798763540111118b78b70792f00@git.kernel.org>
Git-Commit-ID: 0dbdd1bfe0b83798763540111118b78b70792f00
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 24 May 2010 23:08:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0dbdd1bfe0b83798763540111118b78b70792f00
Gitweb:     http://git.kernel.org/tip/0dbdd1bfe0b83798763540111118b78b70792f00
Author:     Peter Huewe <peterhuewe@gmx.de>
AuthorDate: Mon, 24 May 2010 12:13:20 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 24 May 2010 13:33:32 -0700

lib/atomic64_test: fix missing include of linux/kernel.h

Fix a build-failure
(http://kisskb.ellerman.id.au/kisskb/buildresult/2601239/) by adding the
missing include file (linux/kernel.h) for printk and KERN_INFO.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
LKML-Reference: <201005241913.o4OJDKdf010884@imap1.linux-foundation.org>
Cc: Luca Barbieri <luca@luca-barbieri.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 lib/atomic64_test.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index 65e482c..9087d71 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -9,6 +9,7 @@
  * (at your option) any later version.
  */
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <asm/atomic.h>
 
 #define INIT(c) do { atomic64_set(&v, c); r = c; } while (0)
