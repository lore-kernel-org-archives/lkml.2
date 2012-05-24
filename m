Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2EXBIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:08:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57479 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab2EXBIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:08:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/1] perf/core fix
Date: Wed, 23 May 2012 22:08:24 -0300
Message-Id: <1337821705-3941-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please pull,

- Arnaldo

The following changes since commit ab0cce560ef177bdc7a8f73e9962be9d829a7b2c:

  Revert "sched, perf: Use a single callback into the scheduler" (2012-05-23 17:40:51 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

for you to fetch changes up to a1d44b9acdf7b2820ef762846150b4d13b84e075:

  perf evlist: Explicititely initialize input_name (2012-05-23 21:47:51 -0300)

----------------------------------------------------------------
Fix perf evlist uninitialized local variable

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      perf evlist: Explicititely initialize input_name

 tools/perf/builtin-evlist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
