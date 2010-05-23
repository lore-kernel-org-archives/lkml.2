Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0EWJ0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:26:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:57378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab0EWJ0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:26:16 -0400
Date: Sun, 23 May 2010 09:25:45 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, pq@iki.fi,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       pq@iki.fi, tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <1274140110-5841-1-git-send-email-akinobu.mita@gmail.com>
References: <1274140110-5841-1-git-send-email-akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/mmiotrace: Remove redundant instruction prefix checks
Message-ID: <tip-841bca1393d315d79077f272c2918423e36dc364@git.kernel.org>
Git-Commit-ID: 841bca1393d315d79077f272c2918423e36dc364
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 23 May 2010 09:25:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  841bca1393d315d79077f272c2918423e36dc364
Gitweb:     http://git.kernel.org/tip/841bca1393d315d79077f272c2918423e36dc364
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Tue, 18 May 2010 08:48:30 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 23 May 2010 11:02:43 +0200

x86/mmiotrace: Remove redundant instruction prefix checks

Get rid of the duplicated entries in prefix_codes[]
to eliminate redundant checks by skip_prefix().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Pekka Paalanen <pq@iki.fi>
LKML-Reference: <1274140110-5841-1-git-send-email-akinobu.mita@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pf_in.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pf_in.c b/arch/x86/mm/pf_in.c
index df3d5c8..308e325 100644
--- a/arch/x86/mm/pf_in.c
+++ b/arch/x86/mm/pf_in.c
@@ -34,7 +34,7 @@
 /* IA32 Manual 3, 2-1 */
 static unsigned char prefix_codes[] = {
 	0xF0, 0xF2, 0xF3, 0x2E, 0x36, 0x3E, 0x26, 0x64,
-	0x65, 0x2E, 0x3E, 0x66, 0x67
+	0x65, 0x66, 0x67
 };
 /* IA32 Manual 3, 3-432*/
 static unsigned int reg_rop[] = {
