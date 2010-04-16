Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab0DPDJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 23:09:05 -0400
Received: from baikonur.stro.at ([213.239.196.228]:55731 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282Ab0DPDJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 23:09:03 -0400
From: maximilian attems <max@stro.at>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, maximilian attems <max@stro.at>,
       stable@kernel.org, Ulrich Drepper <drepper@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH] fcntl.h: define AT_EACCESS
Date: Fri, 16 Apr 2010 05:08:00 +0200
Message-Id: <1271387280-19565-1-git-send-email-max@stro.at>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

noticed on a klibc build of dash that someone had left out that def:
usr/dash/bltin/test.c:490: error: ‘AT_EACCESS’ undeclared (first use in thiction)

Cc: stable@kernel.org
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: maximilian attems <max@stro.at>
---
 include/linux/fcntl.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 8603740..8bb001d 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -39,6 +39,8 @@
 #define AT_REMOVEDIR		0x200   /* Remove directory instead of
                                            unlinking file.  */
 #define AT_SYMLINK_FOLLOW	0x400   /* Follow symbolic links.  */
+#define AT_EACCESS		0x200	/* Test access permitted for
+					   effective IDs, not real IDs.  */
 
 #ifdef __KERNEL__
 
-- 
1.7.0.4

