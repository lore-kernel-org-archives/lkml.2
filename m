Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0D2BZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 21:25:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:51802 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab0D2BZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 21:25:07 -0400
Date: Thu, 29 Apr 2010 01:24:38 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de
In-Reply-To: <4BCF33BD020000780003B3E4@vpn.id2.novell.com>
References: <4BCF33BD020000780003B3E4@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86-64: Don't export init_level4_pgt
Message-ID: <tip-47f9fe26299ae022ac1e3fa12e7e73def62b7898@git.kernel.org>
Git-Commit-ID: 47f9fe26299ae022ac1e3fa12e7e73def62b7898
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Apr 2010 01:24:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47f9fe26299ae022ac1e3fa12e7e73def62b7898
Gitweb:     http://git.kernel.org/tip/47f9fe26299ae022ac1e3fa12e7e73def62b7898
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Wed, 21 Apr 2010 16:19:57 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 28 Apr 2010 17:25:47 -0700

x86-64: Don't export init_level4_pgt

It's not used by any module, and i386 (as well as some other arches)
also doesn't export its equivalent (swapper_pg_dir).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4BCF33BD020000780003B3E4@vpn.id2.novell.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/x8664_ksyms_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 693920b..1b950d1 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -54,7 +54,6 @@ EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(__memcpy);
 
 EXPORT_SYMBOL(empty_zero_page);
-EXPORT_SYMBOL(init_level4_pgt);
 #ifndef CONFIG_PARAVIRT
 EXPORT_SYMBOL(native_load_gs_index);
 #endif
