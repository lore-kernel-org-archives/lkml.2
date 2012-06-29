Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2F2PbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:31:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56993 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2F2PbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:31:07 -0400
Date: Fri, 29 Jun 2012 17:31:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] OProfile fixlet
Message-ID: <20120629153102.GA2864@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 662f5cedb38c4b88e1cebfd54a88159f2f7ab7b9 Merge branch 'urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile into perf/urgent

 Thanks,

	Ingo

------------------>
Will Deacon (1):
      oprofile: perf: use NR_CPUS instead or nr_cpumask_bits for static array


 drivers/oprofile/oprofile_perf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
index da14432..efc4b7f 100644
--- a/drivers/oprofile/oprofile_perf.c
+++ b/drivers/oprofile/oprofile_perf.c
@@ -25,7 +25,7 @@ static int oprofile_perf_enabled;
 static DEFINE_MUTEX(oprofile_perf_mutex);
 
 static struct op_counter_config *counter_config;
-static struct perf_event **perf_events[nr_cpumask_bits];
+static struct perf_event **perf_events[NR_CPUS];
 static int num_counters;
 
 /*
