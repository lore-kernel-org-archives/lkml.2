Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab1H3FXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:23:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:48768 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab1H3FXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:23:00 -0400
Date: Tue, 30 Aug 2011 05:22:27 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-4009338d62e9d1c21b230bd7ebab6c43c482430e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4E5BCC40.3030501@goop.org>
References: <4E5BCC40.3030501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, cmpxchg: <linux/alternative.h> has LOCK_PREFIX
Git-Commit-ID: 4009338d62e9d1c21b230bd7ebab6c43c482430e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 30 Aug 2011 05:22:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4009338d62e9d1c21b230bd7ebab6c43c482430e
Gitweb:     http://git.kernel.org/tip/4009338d62e9d1c21b230bd7ebab6c43c482430e
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Thu, 18 Aug 2011 11:33:39 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 29 Aug 2011 13:40:25 -0700

x86, cmpxchg: <linux/alternative.h> has LOCK_PREFIX

Not <linux/bitops.h>.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/4E5BCC40.3030501@goop.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cmpxchg_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 3deb725..024b694 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_CMPXCHG_32_H
 #define _ASM_X86_CMPXCHG_32_H
 
-#include <linux/bitops.h> /* for LOCK_PREFIX */
+#include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
 /*
  * Note: if you use set64_bit(), __cmpxchg64(), or their variants, you
