Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab0DCKrs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 06:47:48 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35268 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab0DCKrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 06:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AAkCiIaRFgpnsNq1NjFJSE+sfDh4RmmsuQTM+m4eNQVcv28MpMvYbT8HJ+dAb+Z/6c
         kZfsgFlNwfPKFWH+TLlV9fZ35pzRAKpvVGRqAVQor0db+dZnX/4R1C5lX/QDsXfm1Bj2
         A4ZlaQmrzY2qZ+Y3WqJ7QtCkuQEXoT6k5QqS0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf fixes
Date: Sat,  3 Apr 2010 12:47:37 +0200
Message-Id: <1270291659-6299-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
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

Frederic Weisbecker (2):
      perf: Always build the stub perf_arch_fetch_caller_regs version
      perf: Always build the powerpc perf_arch_fetch_caller_regs version


 arch/powerpc/kernel/misc.S |    2 --
 kernel/perf_event.c        |    3 +--
 2 files changed, 1 insertions(+), 4 deletions(-)
