Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0EPCeB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 22:34:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37093 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab0EPCeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 22:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=snLUPsoZp86kWcPGXvIGny+7hYGg77paJ+vF2Izv55/xacEbxp/JwREHsF3hmatc3n
         zeJo1YjPoTTIBaAe1+gQfbkWA8U8bVGJ/QBMZX9ZmG++IwPQ9GFDVJvpbKQWdR0UD29g
         dZAATxIuF5pDrDuJ1yqsGsHjl3h0loeKPDhfw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [GIT PULL] Lockup detector build fixes
Date: Sun, 16 May 2010 04:33:56 +0200
Message-Id: <1273977240-30800-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <20100515073732.GA17120@elte.hu>
References: <20100515073732.GA17120@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/nmi branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/nmi

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      lockup_detector: Update some config
      lockup_detector: Adapt CONFIG_PERF_EVENT_NMI to other archs
      lockup_detector: Introduce CONFIG_HARDLOCKUP_DETECTOR

Don Zickus (1):
      lockup_detector: Cross arch compile fixes


 arch/Kconfig                  |    7 +++++++
 arch/x86/Kconfig              |    2 +-
 arch/x86/kernel/apic/Makefile |    4 ++--
 include/linux/nmi.h           |    2 +-
 init/Kconfig                  |    8 --------
 kernel/watchdog.c             |   21 ++++++++++++---------
 lib/Kconfig.debug             |   28 ++++++----------------------
 7 files changed, 29 insertions(+), 43 deletions(-)
