Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab0EPA7x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 20:59:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0EPA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 20:59:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/2] perf improvements
Date: Sat, 15 May 2010 21:59:40 -0300
Message-Id: <1273971582-20206-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
LKML-Reference: <new-submission>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

	Now there are 4 patches pending on this branch.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf newt: Exit browser unconditionally when CTRL+C, q or Q is pressed
  perf newt: Add single key shortcuts for zoom into DSO and threads

 tools/perf/util/newt.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

