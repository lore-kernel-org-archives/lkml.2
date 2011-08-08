Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1HHPxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:53:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:50168 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1HHPxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:53:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>, 632923@bugs.debian.org,
        Ben Hutchings <ben@decadent.org.uk>, Christian Ohm <chr.ohm@gmx.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jovi Zhang <bookjovi@gmail.com>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Zhu Yanhai <gaoyang.zyh@taobao.com>
Subject: [GIT PULL 0/4] perf/core fixes
Date: Mon,  8 Aug 2011 12:52:52 -0300
Message-Id: <1312818776-19530-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

	I did it on perf/core but I guess at this point you should just pull it
into tip/perf/urgent :-)

Regards,

- Arnaldo

Jonathan Nieder (1):
  perf tools: do not look at ./config for configuration

Jovi Zhang (1):
  perf probe: Fix coredump introduced by probe module option

Kusanagi Kouichi (1):
  perf tools: Make clean leaves some files

Zhu Yanhai (1):
  perf lock: Dropping unsupported ':r' modifier

 tools/perf/Makefile           |    2 +-
 tools/perf/builtin-lock.c     |    8 ++++----
 tools/perf/util/config.c      |    7 -------
 tools/perf/util/probe-event.c |   12 ++++++++----
 4 files changed, 13 insertions(+), 16 deletions(-)

