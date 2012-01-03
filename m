Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2ACUQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:16:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60729 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2ACUQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:16:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/5] perf/core fixes and improvements
Date: Tue,  3 Jan 2012 18:16:19 -0200
Message-Id: <1325621784-10683-1-git-send-email-acme@infradead.org>
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

Joerg Roedel (1):
  perf kvm: Fix copy & paste error in description

Namhyung Kim (4):
  perf session: Remove impossible condition check
  perf stat: Introduce get_ratio_color() helper
  perf top: Fix a memory leak
  perf script: Kill script_spec__delete

 tools/perf/builtin-kvm.c    |    2 +-
 tools/perf/builtin-script.c |   13 +------
 tools/perf/builtin-stat.c   |   91 ++++++++++++++++--------------------------
 tools/perf/builtin-top.c    |    1 -
 tools/perf/util/session.c   |    3 +-
 5 files changed, 38 insertions(+), 72 deletions(-)

-- 
1.7.8.rc0.35.gee6df

