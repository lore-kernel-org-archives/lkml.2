Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1C1SI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:08:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:43283 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab1C1SI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:08:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andy Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/1] perf/urgent fix
Date: Mon, 28 Mar 2011 15:07:50 -0300
Message-Id: <1301335671-22897-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

	I need to go over symbol.c to clean up the way the long name
is set/freed, but Andrew's solves a real problem and thus I think it
should go in now.

Regards,

- Arnaldo

Andrew Lutomirski (1):
  perf symbols: Fix vsyscall symbol lookup

 tools/perf/util/event.c  |    2 +-
 tools/perf/util/symbol.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

