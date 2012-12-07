Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2LGIj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:39:59 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56654 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab2LGIj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:39:58 -0500
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: yangyongqiang <yangyongqiang01@baidu.com>
Subject: [PATCH] x86: fix a compile error 'a section type conflict'
Date: Fri,  7 Dec 2012 16:37:39 +0800
Message-Id: <1354869459-10858-1-git-send-email-yangyongqiang01@baidu.com>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: yangyongqiang <yangyongqiang01@baidu.com>

Fix a compile error - 'a section type conflict' by removing __initconst.

Signed-off-by: yangyongqiang <yangyongqiang01@baidu.com>
---
 arch/x86/kernel/cpu/perf_event_p6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 7d0270b..436e200 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -19,7 +19,7 @@ static const u64 p6_perfmon_event_map[] =
 
 };
 
-static __initconst u64 p6_hw_cache_event_ids
+static u64 p6_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
-- 
1.7.9.7

