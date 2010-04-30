Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab0D3RhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:37:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54240 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab0D3ReU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:34:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=kMTQ7AJIONEO9r3ZzXjw4Id4IUevRALwGkhuCWPb9f47Bo/Hrq2epxTm+4k5sIzGcc
         CR9sek33ED3BBuIfL5U7JpbdiZuDLF0FJXYBzEHyEz0TMnSZKbkPtCf2uw4d0p09RVsL
         arP26EBFPL7yh1zwRTgEZyMEicdB4LQV4048U=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [GIT PULL] lockdep updates
Date: Fri, 30 Apr 2010 19:34:19 +0200
Message-Id: <1272648859-7203-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the core/locking branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	core/locking

Note there is also a merge of v2.6.34-rc6 because these patches
depend on older per cpu updates.

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      lockdep: Fix redundant_hardirqs_on incremented with irqs enabled
      lockdep: Simplify debug atomic ops


 kernel/lockdep.c           |    7 ++++++-
 kernel/lockdep_internals.h |   10 ++--------
 2 files changed, 8 insertions(+), 9 deletions(-)
