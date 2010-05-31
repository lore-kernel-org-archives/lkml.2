Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab0EaXCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:02:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33476 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0EaXCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=dlL/H7N/09HasndeaFRrFCxCqpw0KJeIhmmh2u85GFv5urR0s6OuPIs9v7ux+g2MsW
         gqur9+Ijb67c69X4fLs1uo7d2gL+PmGVl8REndFZCf9YsyedID+Hx38d6xM9VwI6igTN
         VEthN1VagRKkxHtPS32R9zN0BRxdUpiTqlhFQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf fixes
Date: Tue,  1 Jun 2010 01:02:16 +0200
Message-Id: <1275346940-18498-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      perf: Process comm events by tid
      perf: Use event__process_task from perf sched
      perf: Do the comm inheritance per thread in event__process_task

Borislav Petkov (1):
      perf-record: Check correct pid when forking


 tools/perf/builtin-record.c |    3 +--
 tools/perf/builtin-sched.c  |    1 +
 tools/perf/util/event.c     |   13 ++++---------
 3 files changed, 6 insertions(+), 11 deletions(-)
