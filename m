Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0EQPs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:48:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:55022 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0EQPsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:48:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/3] perf tools fixes
Date: Mon, 17 May 2010 12:47:55 -0300
Message-Id: <1274111278-2838-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

	The record fix for stable doesn't seem needed as the codebase there
is different and the options match the OPT_ macro used for them.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf options: Introduce OPT_U64
  perf tui: Add workaround for slang < 2.1.4

Stephane Eranian (1):
  perf record: Fix bug mismatch with -c option definition

 tools/perf/builtin-record.c     |   11 +++++------
 tools/perf/util/newt.c          |   31 +++++++++++++++++++++----------
 tools/perf/util/parse-options.c |   18 ++++++++++++++++++
 tools/perf/util/parse-options.h |    2 ++
 4 files changed, 46 insertions(+), 16 deletions(-)

