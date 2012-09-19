Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2ISHHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:07:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47869 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2ISHHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:07:19 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-30-50596f2540be
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] tools lib traceevent: Small fixes on error handling path
Date: Wed, 19 Sep 2012 15:58:40 +0900
Message-Id: <1348037924-17568-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During a review on Arnaldo's libtraceevent cleanup patches, I've found
some possible memory leaks and a dangling pointer problem.  Please
take a look at them too.

Thanks,
Namhyung


Namhyung Kim (4):
  tools lib traceevent: Fix error path on process_array()
  tools lib traceevent: Make sure that arg->op.right is set properly
  tools lib traceevent: Free field if an error occurs on process_fields
  tools lib traceevent: Free field if an error occurs on process_flags/symbols

 tools/lib/traceevent/event-parse.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

-- 
1.7.11.4

