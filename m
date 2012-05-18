Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965890Ab2ERIrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:47:01 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50829 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104Ab2ERIq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:46:57 -0400
Message-ID: <4FB60C7A.2080508@linux.vnet.ibm.com>
Date: Fri, 18 May 2012 14:16:50 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>, eranian@google.com
Subject: [PATCH] perf tools: Fixing perf-record documentation for branch stack
 sampling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051808-5564-0000-0000-000002C51545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf tools: Fixing perf-record documentation for branch stack sampling

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-record.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index a1386b2..b38a1f9 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -168,7 +168,7 @@ following filters are defined:
         - any:  any type of branches
         - any_call: any function call or system call
         - any_ret: any function return or system call return
-        - any_ind: any indirect branch
+        - ind_call: any indirect branch
         - u:  only when the branch target is at the user level
         - k: only when the branch target is in the kernel
         - hv: only when the target is at the hypervisor level

