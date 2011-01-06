Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1AFUSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:18:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:40281 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab1AFUSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:18:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/2] perf/core fixes and improvements
Date: Thu,  6 Jan 2011 18:18:07 -0200
Message-Id: <1294345089-7461-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Frederic Weisbecker (1):
  perf tools: Build with frame pointer

Han Pingtian (1):
  perf tools: Fix buffer overflow error when specifying all tracepoints

 tools/perf/Makefile            |    2 +-
 tools/perf/util/parse-events.c |   61 +++++++++++++++++++--------------------
 2 files changed, 31 insertions(+), 32 deletions(-)

