Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab0J1OGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:06:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758818Ab0J1OFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:05:55 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=aIGbYn9KqmIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=WPyIoOwQAAAA:8 a=meVymXHHAAAA:8 a=6lRVBkymSyuEjJ46kiIA:9 a=uzaHdbpw9Ta8v9f41m3QawVuVUUA:4 a=MSl-tDqOz04A:10 a=1DbiqZag68YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101028140554.543037978@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 28 Oct 2010 10:05:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH 3/3] ftrace/MIPS: Enable C Version of recordmcount
References: <20101028140512.441043850@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-MIPS-Enable-C-Version-of-recordmcount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

Selects HAVE_C_RECORDMCOUNT to use the C version of the recordmcount
intead of the old Perl Version of recordmcount.

Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
LKML-Reference: <bb99009a9ac79d3f55a8c8bf1c8bd2bc0e1f160e.1288176026.git.wuzhangjin@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/mips/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 46cae2b..144e4b3 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -9,6 +9,7 @@ config MIPS
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_C_RECORDMCOUNT
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-- 
1.7.1


