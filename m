Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030844Ab2CGWlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:41:42 -0500
Received: from outmail007.snc4.facebook.com ([66.220.144.141]:60951 "EHLO
	intmgw004.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965333Ab2CGWlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:41:37 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
Date: Wed,  7 Mar 2012 14:41:17 -0800
Message-Id: <1331160079-13821-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series refactors existing code a bit and adds sort by 
inclusive time (time spent in the function + callees).

Sample command lines:

# perf record -ag -- sleep 1
# perf report -g graph,0.5,callee -n -s inclusive

Known bugs:

total_period computation is broken for order=callee

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
