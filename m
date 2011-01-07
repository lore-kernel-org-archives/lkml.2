Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1AGRJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:09:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60166 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1AGRJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:09:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Z3S7i1kqZtLsu2akLTRPAq7IrNajfgCdR3M+RPa83ZP6UmmDQEl/NnTwLn16yYcyfV
         3CQNrthjNEvHfJYOivR15V9I+h5RPqX932ESo7ZOOTeojpwVfELUJheStRbdmdVkygQt
         ztFfGFzp7eeQpwc3/GT8046UafJB+Kka8Qwkc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: [RFC GIT PULL v2] perf updates
Date: Fri,  7 Jan 2011 18:08:58 +0100
Message-Id: <1294420140-6090-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core
	
The changelog of the rbp/pt_regs patch has been refined and
the CFI annotations reported by Jan (and another I found lately)
have been fixed, hopefully.

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      x86: Save rbp in pt_regs on irq entry

Rakib Mullick (1):
      x86, dumpstack: Fix unused variable warning


 arch/x86/kernel/dumpstack.c |    6 ------
 arch/x86/kernel/entry_64.S  |   36 +++++++++++++++++++++++-------------
 2 files changed, 23 insertions(+), 19 deletions(-)
