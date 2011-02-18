Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab1BRSsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:48:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:38975 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab1BRSsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:48:00 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michael Witten <mfwitten@gmail.com>
Subject: [GIT PULL 0/4] perf/core cleanups
Date: Fri, 18 Feb 2011 16:47:48 -0200
Message-Id: <1298054872-16434-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

	This just trims the Makefile perf stole from git aeons ago, trowing
away things that either are unused or plain don't make any sense for us.

Regards,

- Arnaldo

Michael Witten (4):
  perf tools: Makefile: Remove vestigial git-specific cruft
  perf tools: Makefile: Remove platform-specific cruft
  perf tools: Makefile: Remove tool-specific cruft
  perf tools: Makefile: Remove various and sundry cruft

 tools/perf/.gitignore      |    1 -
 tools/perf/Makefile        |  576 ++------------------------------------------
 tools/perf/util/exec_cmd.c |   19 --
 tools/perf/util/util.h     |   26 --
 4 files changed, 18 insertions(+), 604 deletions(-)

