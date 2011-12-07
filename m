Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1LGPru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:47:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38092 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab1LGPrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:47:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>, Anton Blanchard <anton@samba.org>,
        Arun Sharma <asharma@fb.com>, David Ahern <dsahern@gmail.com>,
        devel@openvz.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Wed,  7 Dec 2011 13:47:27 -0200
Message-Id: <1323272849-15077-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/urgent

Regards,

- Arnaldo

Andrew Vagin (1):
  perf header: Use event_name() to get an event name

Anton Blanchard (1):
  perf stat: Failure with "Operation not supported"

 tools/perf/builtin-stat.c |    3 ++-
 tools/perf/util/header.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
1.7.8.rc0.35.gee6df

