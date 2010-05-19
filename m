Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab0ESKhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:37:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46889 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab0ESKh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=NA3DSjua78ECEy6CgmRpkuA1zLNnVwQIm+Jn91qHb0jD5MsjCnn4QKC7mWLK3URNwL
         /MiJ3Y9ycaZG3X4hLoZY31GFH1K6l22mfJ19qmQaG63cjqOnHAtmZtVxu4l6Dz3v+HY/
         U/3ERof/gM6yBcuVrym8GohWINJl+CDjwqSGo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [GIT PULL] Lockup detector updates
Date: Wed, 19 May 2010 12:37:33 +0200
Message-Id: <1274265455-1948-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
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

Don Zickus (1):
      lockup_detector: Convert per_cpu to __get_cpu_var for readability

Frederic Weisbecker (1):
      lockup_detector: Don't enable the lockup detector by default


 kernel/watchdog.c |   35 +++++++++++++++++------------------
 lib/Kconfig.debug |    1 -
 2 files changed, 17 insertions(+), 19 deletions(-)
