Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1LLN01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 08:26:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43014 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab1LLN0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 08:26:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, devel@openvz.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/3] perf/core fixes and improvements
Date: Mon, 12 Dec 2011 11:26:06 -0200
Message-Id: <1323696369-14688-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

Regards,

- Arnaldo

Andrew Vagin (1):
  perf tools: Add ability to synthesize event according to a sample

Robert Richter (2):
  perf script: Fix mem leaks and NULL pointer checks around strdup()s
  perf script: Implement option for system-wide profiling

 tools/perf/builtin-script.c |   63 +++++++++++++++++++++-------------
 tools/perf/util/event.h     |    3 ++
 tools/perf/util/evsel.c     |   79 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h   |    8 ++++
 4 files changed, 129 insertions(+), 24 deletions(-)

-- 
1.7.8.rc0.35.gee6df

