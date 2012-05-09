Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581Ab2EIRoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:44:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59431 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab2EIRol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:44:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL 0/1] perf/urgent fix
Date: Wed,  9 May 2012 14:43:58 -0300
Message-Id: <1336585439-32378-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 09c0211c0bb0e40231e6ee9a35041d467ed72f16:

  perf: Turn off compiler warnings for flex and bison generated files (2012-05-07 10:03:01 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/urgent

for you to fetch changes up to 20d23aaa31da295378abff4272716e3dfc72baf0:

  perf stat: handle ENXIO error for perf_event_open (2012-05-09 14:14:41 -0300)

----------------------------------------------------------------
Fix for perf/urgent:

. Fix handling of older kernels on PPC, from David Ahern.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
David Ahern (1):
      perf stat: handle ENXIO error for perf_event_open

 tools/perf/builtin-stat.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)
