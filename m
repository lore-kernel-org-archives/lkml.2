Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab2CVVZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:25:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42065 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2CVVZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:25:49 -0400
Date: Thu, 22 Mar 2012 14:25:36 -0700
From: tip-bot for Thierry Reding <thierry.reding@avionic-design.de>
Message-ID: <tip-13354dc412c36fe554f9904a92f1268c74af7e87@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, thierry.reding@avionic-design.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, thierry.reding@avionic-design.de
In-Reply-To: <1332366608-2695-2-git-send-email-thierry.reding@avionic-design.de>
References: <1332366608-2695-2-git-send-email-thierry.reding@avionic-design.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32:
  Fix typo for mq_getsetattr in syscall table
Git-Commit-ID: 13354dc412c36fe554f9904a92f1268c74af7e87
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 22 Mar 2012 14:25:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13354dc412c36fe554f9904a92f1268c74af7e87
Gitweb:     http://git.kernel.org/tip/13354dc412c36fe554f9904a92f1268c74af7e87
Author:     Thierry Reding <thierry.reding@avionic-design.de>
AuthorDate: Wed, 21 Mar 2012 22:50:08 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 22 Mar 2012 12:42:41 -0700

x86-32: Fix typo for mq_getsetattr in syscall table

Syscall 282 was mistakenly named mq_getsetaddr instead of mq_getsetattr.
When building uClibc against the Linux kernel this would result in a
shared library that doesn't provide the mq_getattr() and mq_setattr()
functions.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Link: http://lkml.kernel.org/r/1332366608-2695-2-git-send-email-thierry.reding@avionic-design.de
Cc: <stable@vger.kernel.org> v3.3
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/syscalls/syscall_32.tbl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index ce98e28..e7e67cc 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -288,7 +288,7 @@
 279	i386	mq_timedsend		sys_mq_timedsend		compat_sys_mq_timedsend
 280	i386	mq_timedreceive		sys_mq_timedreceive		compat_sys_mq_timedreceive
 281	i386	mq_notify		sys_mq_notify			compat_sys_mq_notify
-282	i386	mq_getsetaddr		sys_mq_getsetattr		compat_sys_mq_getsetattr
+282	i386	mq_getsetattr		sys_mq_getsetattr		compat_sys_mq_getsetattr
 283	i386	kexec_load		sys_kexec_load			compat_sys_kexec_load
 284	i386	waitid			sys_waitid			compat_sys_waitid
 # 285 sys_setaltroot
