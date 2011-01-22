Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1AVBQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:16:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:47641 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1AVBQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:16:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Dave Martin <dave.martin@linaro.org>,
        "Dr. David Alan Gilbert" <david.gilbert@linaro.org>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Fri, 21 Jan 2011 23:16:06 -0200
Message-Id: <1295658968-23217-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Dr. David Alan Gilbert (1):
  perf symbols: Fix annotation of thumb code

Han Pingtian (1):
  perf test: Use cpu_map->[cpu] when setting affinity

 tools/perf/builtin-test.c |   13 +++++++++----
 tools/perf/util/symbol.c  |    7 +++++++
 2 files changed, 16 insertions(+), 4 deletions(-)

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Dave Martin <dave.martin@linaro.org>
Cc: Dr. David Alan Gilbert <david.gilbert@linaro.org>
Cc: Han Pingtian <phan@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
