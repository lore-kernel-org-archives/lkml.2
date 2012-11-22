Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab2KVUzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:55:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab2KVS6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:32 -0500
Date: Wed, 21 Nov 2012 18:10:57 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-f836e35a98ab3b2f0d4c8730610e4a4a7f533505@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1353123563-3103-33-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-33-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm: change low/
 hignmem_pfn_init to static on 32bit
Git-Commit-ID: f836e35a98ab3b2f0d4c8730610e4a4a7f533505
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 21 Nov 2012 18:11:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f836e35a98ab3b2f0d4c8730610e4a4a7f533505
Gitweb:     http://git.kernel.org/tip/f836e35a98ab3b2f0d4c8730610e4a4a7f533505
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 16 Nov 2012 19:39:09 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 17 Nov 2012 11:59:37 -0800

x86, mm: change low/hignmem_pfn_init to static on 32bit

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1353123563-3103-33-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init_32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 0ae1ba8..322ee56 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -575,7 +575,7 @@ early_param("highmem", parse_highmem);
  * artificially via the highmem=x boot parameter then create
  * it:
  */
-void __init lowmem_pfn_init(void)
+static void __init lowmem_pfn_init(void)
 {
 	/* max_low_pfn is 0, we already have early_res support */
 	max_low_pfn = max_pfn;
@@ -611,7 +611,7 @@ void __init lowmem_pfn_init(void)
  * We have more RAM than fits into lowmem - we try to put it into
  * highmem, also taking the highmem=x boot parameter into account:
  */
-void __init highmem_pfn_init(void)
+static void __init highmem_pfn_init(void)
 {
 	max_low_pfn = MAXMEM_PFN;
 
