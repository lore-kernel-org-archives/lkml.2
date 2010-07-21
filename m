Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab0GUWiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 18:38:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:42891 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758830Ab0GUWiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 18:38:15 -0400
Date: Wed, 21 Jul 2010 22:37:59 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1279731838-1522-6-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-6-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: Add __init attribute to setup_xstate_features()
Message-ID: <tip-4995b9dba908436c1611454f9bd2cb3ddf6babee@git.kernel.org>
Git-Commit-ID: 4995b9dba908436c1611454f9bd2cb3ddf6babee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 22:37:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4995b9dba908436c1611454f9bd2cb3ddf6babee
Gitweb:     http://git.kernel.org/tip/4995b9dba908436c1611454f9bd2cb3ddf6babee
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 21 Jul 2010 19:03:56 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 21 Jul 2010 14:06:05 -0700

x86, xsave: Add __init attribute to setup_xstate_features()

This is called only from initialization code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1279731838-1522-6-git-send-email-robert.richter@amd.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/xsave.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 3b44a9b..cfc7901 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -370,7 +370,7 @@ static inline void xstate_enable(u64 mask)
  * Record the offsets and sizes of different state managed by the xsave
  * memory layout.
  */
-static void setup_xstate_features(void)
+static void __init setup_xstate_features(void)
 {
 	int eax, ebx, ecx, edx, leaf = 0x2;
 
