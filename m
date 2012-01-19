Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab2ASVlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 16:41:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38203 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab2ASVlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 16:41:01 -0500
Date: Thu, 19 Jan 2012 13:40:43 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-4f2f81a5621de47d42476d0b929be2e0d565df84@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, dmitry.kasatkin@intel.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, dmitry.kasatkin@intel.com,
        tglx@linutronix.de
In-Reply-To: <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
References: <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, syscall:
  Need __ARCH_WANT_SYS_IPC for 32 bits
Git-Commit-ID: 4f2f81a5621de47d42476d0b929be2e0d565df84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Jan 2012 13:40:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f2f81a5621de47d42476d0b929be2e0d565df84
Gitweb:     http://git.kernel.org/tip/4f2f81a5621de47d42476d0b929be2e0d565df84
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 19 Jan 2012 12:41:25 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Jan 2012 12:57:09 -0800

x86, syscall: Need __ARCH_WANT_SYS_IPC for 32 bits

In checkin

  303395ac3bf3 x86: Generate system call tables and unistd_*.h from tables

the feature macros in <asm/unistd.h> were unified between 32 and 64
bits.  Unfortunately 32 bits requires __ARCH_WANT_SYS_IPC and this was
inadvertently dropped.

Reported-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com
---
 arch/x86/include/asm/unistd.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index b4a3db7..21f77b8 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -7,6 +7,7 @@
 #  include <asm/unistd_32.h>
 #  define __ARCH_WANT_IPC_PARSE_VERSION
 #  define __ARCH_WANT_STAT64
+#  define __ARCH_WANT_SYS_IPC
 #  define __ARCH_WANT_SYS_OLD_MMAP
 #  define __ARCH_WANT_SYS_OLD_SELECT
 
