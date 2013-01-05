Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3AEBtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 20:49:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:51155 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3AEBtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 20:49:21 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-pm@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH/RFC 0/1] Delete legacy power trace API
Date: Fri,  4 Jan 2013 20:49:03 -0500
Message-Id: <1357350544-32704-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The actual deletion is mind-numbingly simple; and if you go by the
comments in the code, it is well overdue.  However, in discussions
with Frederic, he suggested to me that those comments might have
been overly optimistic, and that there may still be people out
there who are still unknowingly using this dead API.

So, that is the crux of the RFC component -- to check whether the
comments saying "delete by v3.1" can be taken at face value, or
whether they were overly optimistic, and hence this stuff is still
actively used even though it is overdue for deletion.

Thanks,
Paul.
---

Paul Gortmaker (1):
  tracing: remove deprecated power trace API

 Documentation/trace/events-power.txt | 27 +----------
 arch/arm/mach-omap2/pm34xx.c         |  2 -
 arch/x86/kernel/process.c            |  6 ---
 drivers/cpufreq/cpufreq.c            |  1 -
 drivers/cpuidle/cpuidle.c            |  2 -
 include/trace/events/power.h         | 92 ------------------------------------
 kernel/trace/Kconfig                 | 15 ------
 kernel/trace/power-traces.c          |  3 --
 8 files changed, 1 insertion(+), 147 deletions(-)

-- 
1.8.1

