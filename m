Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2BTVLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:11:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37149 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab2BTVLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:11:17 -0500
Date: Mon, 20 Feb 2012 13:10:41 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-81620bb7acee40dda4dbfdd061cd22c373529372@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        lethal@linux-sh.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, lethal@linux-sh.org
In-Reply-To: <1328677745-20121-18-git-send-email-hpa@zytor.com>
References: <1328677745-20121-18-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] sh: Remove unnecessary posix_types.
 h type overrides
Git-Commit-ID: 81620bb7acee40dda4dbfdd061cd22c373529372
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:11:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  81620bb7acee40dda4dbfdd061cd22c373529372
Gitweb:     http://git.kernel.org/tip/81620bb7acee40dda4dbfdd061cd22c373529372
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Tue, 7 Feb 2012 21:09:01 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 14 Feb 2012 12:01:29 -0800

sh: Remove unnecessary posix_types.h type overrides

Remove type overrides in <asm/posix_types.h> for the sh architecture
that are no longer necessary.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/1328677745-20121-18-git-send-email-hpa@zytor.com
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/include/asm/posix_types_32.h |    5 -----
 arch/sh/include/asm/posix_types_64.h |    4 ----
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/arch/sh/include/asm/posix_types_32.h b/arch/sh/include/asm/posix_types_32.h
index 6a9ceaa..abda584 100644
--- a/arch/sh/include/asm/posix_types_32.h
+++ b/arch/sh/include/asm/posix_types_32.h
@@ -12,11 +12,6 @@ typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
 #define __kernel_gid_t __kernel_gid_t
 
-typedef unsigned int	__kernel_uid32_t;
-#define __kernel_uid32_t __kernel_uid32_t
-typedef unsigned int	__kernel_gid32_t;
-#define __kernel_gid32_t __kernel_gid32_t
-
 typedef unsigned short	__kernel_old_uid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
 typedef unsigned short	__kernel_old_gid_t;
diff --git a/arch/sh/include/asm/posix_types_64.h b/arch/sh/include/asm/posix_types_64.h
index 8cd1148..fcda07b 100644
--- a/arch/sh/include/asm/posix_types_64.h
+++ b/arch/sh/include/asm/posix_types_64.h
@@ -17,10 +17,6 @@ typedef int		__kernel_ssize_t;
 #define __kernel_ssize_t __kernel_ssize_t
 typedef int		__kernel_ptrdiff_t;
 #define __kernel_ptrdiff_t __kernel_ptrdiff_t
-typedef unsigned int	__kernel_uid32_t;
-#define __kernel_uid32_t __kernel_uid32_t
-typedef unsigned int	__kernel_gid32_t;
-#define __kernel_gid32_t __kernel_gid32_t
 
 typedef unsigned short	__kernel_old_uid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
