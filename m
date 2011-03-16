Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1CPTtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:49:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:38116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1CPTtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:49:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Ingo Molnar <mingo@elte.hu>, Josh Hunt <johunt@akamai.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, stable@kernel.org,
        Tapan Dhimant <tdhimant@akamai.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 0/2] perf/urgent fixes
Date: Wed, 16 Mar 2011 16:48:17 -0300
Message-Id: <1300304899-21920-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Josh Hunt (1):
  perf tools: Version incorrect with some versions of grep

Marcin Slusarz (1):
  perf lock: Fix sorting by wait_min

 tools/perf/builtin-lock.c        |   13 ++++++++++++-
 tools/perf/util/PERF-VERSION-GEN |    8 ++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

