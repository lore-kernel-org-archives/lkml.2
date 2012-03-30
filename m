Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934606Ab2C3RlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:41:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47749 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934419Ab2C3Rku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:40:50 -0400
Date: Fri, 30 Mar 2012 10:40:28 -0700
From: tip-bot for Richard Weinberger <richard@nod.at>
Message-ID: <tip-35372a7d45291140a97518a8d1c8cb0e31ee2bb7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, richard@nod.at, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@suse.com, richard@nod.at, tglx@linutronix.de
In-Reply-To: <1333064283-3109-1-git-send-email-richard@nod.at>
References: <1333064283-3109-1-git-send-email-richard@nod.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: spinlock.h: Remove REG_PTR_MODE
Git-Commit-ID: 35372a7d45291140a97518a8d1c8cb0e31ee2bb7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 30 Mar 2012 10:40:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35372a7d45291140a97518a8d1c8cb0e31ee2bb7
Gitweb:     http://git.kernel.org/tip/35372a7d45291140a97518a8d1c8cb0e31ee2bb7
Author:     Richard Weinberger <richard@nod.at>
AuthorDate: Fri, 30 Mar 2012 01:38:03 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 30 Mar 2012 10:01:59 -0700

x86: spinlock.h: Remove REG_PTR_MODE

REG_PTR_MODE has no users at all.

Signed-off-by: Richard Weinberger <richard@nod.at>
Link: http://lkml.kernel.org/r/1333064283-3109-1-git-send-email-richard@nod.at
Acked-by: Acked-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/spinlock.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 76bfa2c..b315a33 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -20,10 +20,8 @@
 
 #ifdef CONFIG_X86_32
 # define LOCK_PTR_REG "a"
-# define REG_PTR_MODE "k"
 #else
 # define LOCK_PTR_REG "D"
-# define REG_PTR_MODE "q"
 #endif
 
 #if defined(CONFIG_X86_32) && \
