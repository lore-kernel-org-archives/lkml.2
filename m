Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0GHEhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:37:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61732 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab0GHEhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:37:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=pp7W/T6qd80zdf5H4QzrL+5LTDr2I1LxQdqyuA90ANOCP9iDT54VU17v7NKMM90GpU
         9uz9vhdIxSjbYWuqQiY0ZmQpP/A3AKppd/TPKmwPh7ho06cPKj+o2u8ZyGlIrEGn4Fhd
         wZQmLP504OgB3WpYob8ip5w+Alu+nCJbUGDh4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       "2 . 6 . 31 . x-2 . 6 . 34 . x" <stable@kernel.org>
Subject: [GIT PULL] perf fixes
Date: Thu,  8 Jul 2010 06:36:49 +0200
Message-Id: <1278563811-21818-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

This resurrects flat and graph (absolute fractals) callchains.
All tested with and without newt.

As you know there are still things to fix: filtering by parents (probably a
regression) and dso multiple callchains (not a regression).

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      perf: Resurrect flat callchains
      perf: Sync callchains with period based hits


 tools/perf/builtin-report.c |    2 +-
 tools/perf/util/callchain.c |   35 ++++++++++++++++++-----------------
 tools/perf/util/callchain.h |    5 ++++-
 3 files changed, 23 insertions(+), 19 deletions(-)
