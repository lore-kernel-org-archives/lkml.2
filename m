Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab2GQCOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:14:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63871 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab2GQCOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:14:42 -0400
MIME-Version: 1.0
Date: Tue, 17 Jul 2012 10:14:41 +0800
Message-ID: <CACV3sbKF=CX+2jWEWesfCA6rBoQ3wDM4-5ac9MuBtVbCtMRHdQ@mail.gmail.com>
Subject: [PATCH] [TRIVIAL] perf: missing struct before structure name
From: Jovi Zhang <bookjovi@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Jiri Kosina <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3abcb73682893ed2bde318d17f1cc3430bf70224 Mon Sep 17 00:00:00 2001
From: Jovi Zhang <bookjovi@gmail.com>
Date: Tue, 17 Jul 2012 17:21:56 +0800
Subject: [PATCH] [TRIVIAL] perf: missing struct before structure name

when CONFIG_PERF_EVENTS disabled, there will have a compiliation error,
because missing struct before structure name.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 arch/x86/include/asm/perf_event.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/perf_event.h
b/arch/x86/include/asm/perf_event.h
index 588f52e..2643877 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -235,7 +235,7 @@ struct perf_guest_switch_msr {
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
 #else
-static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
+static inline struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
 	*nr = 0;
 	return NULL;
-- 
1.7.9.7
