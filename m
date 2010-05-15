Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0EOXvD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 19:51:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:44052 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab0EOXu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 19:50:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/2] perf improvement and fix
Date: Sat, 15 May 2010 20:50:42 -0300
Message-Id: <1273967444-18035-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
LKML-Reference: <new-submission>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf newt: Make <- exit the ui_browser
  perf newt: Fix the 'A'/'a' shortcut for annotate

 tools/perf/util/newt.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

