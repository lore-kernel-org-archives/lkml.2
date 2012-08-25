Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2HYCSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 22:18:24 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43965 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2HYCSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 22:18:21 -0400
MIME-Version: 1.0
Date: Sat, 25 Aug 2012 10:18:20 +0800
Message-ID: <CAPgLHd_ndLkDD7Q1WyqHifMYek9U3-cY0xrNdWfu+tfiDtiHdw@mail.gmail.com>
Subject: [PATCH] kdump: remove unused including <generated/utsrelease.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: ebiederm@xmission.com
Cc: yongjun_wei@trendmicro.com.cn, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>


Remove including <generated/utsrelease.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 kernel/kexec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 0668d58..5e4bd78 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -21,7 +21,6 @@
 #include <linux/hardirq.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
-#include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/numa.h>
 #include <linux/suspend.h>


