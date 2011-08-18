Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1HRTb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:31:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53076 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1HRTbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:31:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <daahern@cisco.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/3] perf/core improvements
Date: Thu, 18 Aug 2011 16:31:07 -0300
Message-Id: <1313695870-31028-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

Regards,

- Arnaldo

Stephane Eranian (3):
  perf annotate: Make output more readable
  perf annotate: Add --symfs option
  perf stat: Add -o and --append options

 tools/perf/Documentation/perf-annotate.txt |   11 ++
 tools/perf/Documentation/perf-stat.txt     |    7 ++
 tools/perf/builtin-annotate.c              |    6 +
 tools/perf/builtin-stat.c                  |  155 ++++++++++++++++-----------
 tools/perf/util/annotate.c                 |    5 +-
 tools/perf/util/color.c                    |    2 +-
 tools/perf/util/symbol.c                   |    2 +
 tools/perf/util/symbol.h                   |    4 +-
 8 files changed, 126 insertions(+), 66 deletions(-)

