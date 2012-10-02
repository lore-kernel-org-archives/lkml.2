Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab2JBPWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:22:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55384 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2JBPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:22:44 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] perf tools: Bash completion update
Date: Wed,  3 Oct 2012 00:21:31 +0900
Message-Id: <1349191294-6926-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset improves bash completion support for perf tools.  Some
option names are really painful to type so here comes a support for
completing those long option names.  But I still think the
--showcpuutilization option needs to be renamed (at least adding a
couple of dashes in it).

Thanks,
Namhyung


Namhyung Kim (3):
  perf tools: Check existence of _get_comp_words_by_ref when bash completing
  perf tools: Complete long option names of perf command
  perf tools: Long option completion support for each subcommands

 tools/perf/bash_completion      |   36 +++++++++++++++++++++++++++++-------
 tools/perf/util/parse-options.c |    8 ++++++++
 tools/perf/util/parse-options.h |    1 +
 3 files changed, 38 insertions(+), 7 deletions(-)

-- 
1.7.9.2

