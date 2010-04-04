Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0DDOg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:36:59 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53038 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab0DDOgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:36:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rnSWDMZ4B6wXYghLrIUdQ2oE2HeURXtNdIQnmCSBZIqyIkbVRsmrJF9OIazKPmvrhf
         ogMNbdsi09Cc74sDbXm23xwuY08nnRRvatoEawbPVk8I4l1al7ohNKIU705i9NGFOPNc
         GMRipPl+syWgqXfAHuVkm8FGfviwa7Dg5GGHs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>, Stephane Eranian <eranian@google.com>
Subject: [GIT PULL] perf updates
Date: Sun,  4 Apr 2010 16:36:40 +0200
Message-Id: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      perf: Drop the frame reliablity check
      perf: Fetch hot regs from the template caller

Arnd Bergmann (1):
      perf_event: Make perf fd non seekable

Hitoshi Mitake (1):
      Swap inclusion order of util.h and string.h in util/string.c


 arch/x86/kernel/cpu/perf_event.c |    3 +--
 include/trace/ftrace.h           |   23 ++++++++++++-----------
 kernel/perf_event.c              |    1 +
 tools/perf/util/string.c         |    2 +-
 4 files changed, 15 insertions(+), 14 deletions(-)
