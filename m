Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0IQCs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 22:48:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41806 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0IQCs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 22:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=xLlUVqxgDxHS93pawUIEPJTfOb+D8XeVqsEGYIb3EV4rgYvH9GCyuAasKCBQYuCblx
         /8o++SbPRFKLg1AOE1aq67XSWmNltD5pOv15YlHS0VXL7z6eGrjFy5DxTMvl0BvRnNYG
         CuEh43p3M+mmSb647ZcDC/Ekypsz92TBQNiVc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>
Subject: [GIT PULL] hw_breakpoint fixes
Date: Fri, 17 Sep 2010 04:48:20 +0200
Message-Id: <1284691702-32269-1-git-send-regression-fweisbec@gmail.com>
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

Frederic Weisbecker (1):
      x86: Fix instruction breakpoint encoding

Matt Helsley (1):
      hw breakpoints: Fix pid namespace bug


 arch/x86/include/asm/hw_breakpoint.h |    2 +-
 arch/x86/kernel/hw_breakpoint.c      |   40 ++++++++++++++++-----------------
 kernel/hw_breakpoint.c               |    3 +-
 3 files changed, 22 insertions(+), 23 deletions(-)
