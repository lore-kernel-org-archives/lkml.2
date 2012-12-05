Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2LEG4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 01:56:47 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44066 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab2LEG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 01:56:45 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-fc-50bef02b90cd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH v2 0/3] perf hists: Changes on hists__{match,link}
Date: Wed,  5 Dec 2012 15:56:40 +0900
Message-Id: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

I exchanged arguments of hist_entry__cmp() and friends as you
requested.  You can get this on my perf/link-v2 branch at

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Thanks,
Namhyung


Namhyung Kim (3):
  perf hists: Exchange order of comparing items when collapsing hists
  perf hists: Link hist entries before inserting to an output tree
  perf diff: Use internal rb tree for compute resort

 tools/perf/builtin-diff.c | 95 +++++++++++++++++++++--------------------------
 tools/perf/util/hist.c    | 51 ++++++++++++++++++-------
 2 files changed, 80 insertions(+), 66 deletions(-)

-- 
1.7.11.7

