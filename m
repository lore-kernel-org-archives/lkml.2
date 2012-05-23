Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965150Ab2EWPZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:25:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab2EWPZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:25:53 -0400
Date: Wed, 23 May 2012 08:25:40 -0700
From: tip-bot for Anshuman Khandual <khandual@linux.vnet.ibm.com>
Message-ID: <tip-2e49a948be1e282d2c1477c5a3b5ed23f5987723@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, khandual@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        khandual@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <4FB60C7A.2080508@linux.vnet.ibm.com>
References: <4FB60C7A.2080508@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Fix documentation for branch stack sampling
Git-Commit-ID: 2e49a948be1e282d2c1477c5a3b5ed23f5987723
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:25:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e49a948be1e282d2c1477c5a3b5ed23f5987723
Gitweb:     http://git.kernel.org/tip/2e49a948be1e282d2c1477c5a3b5ed23f5987723
Author:     Anshuman Khandual <khandual@linux.vnet.ibm.com>
AuthorDate: Fri, 18 May 2012 14:16:50 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 12:47:45 -0300

perf record: Fix documentation for branch stack sampling

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/4FB60C7A.2080508@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
