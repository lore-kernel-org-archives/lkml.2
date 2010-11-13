Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0KMVh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 16:37:59 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37241 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab0KMVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 16:37:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=H7dZ7Mo3ADDuxWuXghV4aO8ou8T4TxUjk81Js4VQmmuHFYH9zdmKpfqF/UhH0Maksd
         lyaiVbv4JzArzfzzQyu3ARPDY9gBxMf0rxZiAILq0VK5AB7/0KCySpb1QWLdrbP7Axe6
         p04klZHY/kUrNnlJ4+SQ+wx7Wlie52FVt+YHY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Stefaniuc <mstefani@redhat.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Alexandre Julliard <julliard@winehq.org>
Subject: [GIT PULL] hw-breakpoint fixes
Date: Sat, 13 Nov 2010 22:37:51 +0100
Message-Id: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com>
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
      x86: Ignore trap bits on single step exceptions

Jason Wessel (1):
      perf,hw_breakpoint: Initialize hardware api earlier


 arch/x86/kernel/hw_breakpoint.c |    4 ++++
 include/linux/hw_breakpoint.h   |    4 ++++
 kernel/hw_breakpoint.c          |    3 +--
 kernel/perf_event.c             |    6 ++++++
 4 files changed, 15 insertions(+), 2 deletions(-)
