Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2E3B5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:57:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:36892 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab2E3B4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:56:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/4] Annotation improvements for perf/core
Date: Tue, 29 May 2012 22:56:38 -0300
Message-Id: <1338343002-5271-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling, contains what is in my perf/urgent branch.

- Arnaldo

The following changes since commit a44b45f236dd1c1a8caccf9a078adf2941a20267:

  perf annotate browser: The idx_asm field should be used in asm only view (2012-05-29 20:52:38 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 05e8b0804ec423a440882e7adecb36e7ac43e56f:

  perf ui browser: Stop using 'self' (2012-05-29 22:42:18 -0300)

----------------------------------------------------------------
Annotation improvements for perf/core

. Make the annotatation toggles (hide_src_code, jump_arrows, use_offset, etc)
  global so that navigation doesn't resets them on new annotations.

. Introduce an '[annotate]' config file section to allow permanent changes
  to the annotate browser defaults.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (4):
      perf annotate browser: Make feature toggles global
      perf config: Allow '_' in config file variable names
      perf annotate browser: Read perf config file for settings
      perf ui browser: Stop using 'self'

 tools/perf/Documentation/perfconfig.example |    8 +
 tools/perf/ui/browser.c                     |  182 ++++++++-------
 tools/perf/ui/browser.h                     |    1 +
 tools/perf/ui/browsers/annotate.c           |  258 +++++++++++++-------
 tools/perf/ui/browsers/hists.c              |  338 +++++++++++++--------------
 tools/perf/util/config.c                    |    2 +-
 6 files changed, 440 insertions(+), 349 deletions(-)
