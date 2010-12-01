Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0LABUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:20:16 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44876 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab0LABUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:20:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Julia Lawall <julia@diku.dk>, Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/2] perf/core fixes
Date: Tue, 30 Nov 2010 23:19:48 -0200
Message-Id: <1291166390-19467-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

	Now there are 13 outstanding patches in this branch.

Regards,

- Arnaldo

Corey Ashford (1):
  perf tools: fix event parsing of comma-separated tracepoint events

Don Zickus (1):
  perf packaging: add memcpy to perf MANIFEST

 tools/perf/MANIFEST            |    1 +
 tools/perf/util/parse-events.c |   12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

