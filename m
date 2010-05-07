Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab0EGSks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:40:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52776 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab0EGSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:40:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 0/1] perf list documentation changes
Date: Fri,  7 May 2010 15:40:27 -0300
Message-Id: <1273257628-15215-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

Arnaldo Carvalho de Melo (1):
  perf list: Improve the raw hw event descriptor documentation

 tools/perf/Documentation/perf-list.txt |   19 ++++++++++++++++---
 tools/perf/util/parse-events.c         |    3 ++-
 2 files changed, 18 insertions(+), 4 deletions(-)

