Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab0GPSJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:09:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:49054 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764Ab0GPSJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:09:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [GIT PULL 0/3] perf/core fixes and improvements
Date: Fri, 16 Jul 2010 15:09:30 -0300
Message-Id: <1279303773-27861-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Masami Hiramatsu (3):
  perf probe: Fix error message if get_real_path() failed
  perf probe: Support comp_dir to find an absolute source path
  perf probe: Fix the logic of die_compare_name

 tools/perf/util/probe-event.c  |   69 ++++++++++++++++++++++++++++
 tools/perf/util/probe-event.h  |    1 +
 tools/perf/util/probe-finder.c |   96 ++++++++++++++--------------------------
 3 files changed, 103 insertions(+), 63 deletions(-)

