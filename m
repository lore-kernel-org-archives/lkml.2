Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab0FJQIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:08:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:52791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473Ab0FJQIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:08:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Michal Marek <mmarek@suse.cz>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/1] perf/core Improvement for 2.6.36
Date: Thu, 10 Jun 2010 13:08:10 -0300
Message-Id: <1276186091-19178-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

	I tested this on RHEL6-Beta, fedora 11 x86-64 and Debian PARISC64
squeeze/sid.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf tools: Reorganize the Makefile feature tests

 tools/perf/Makefile          |  109 ++++++++++++++++++++-------------------
 tools/perf/feature-tests.mak |  119 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 175 insertions(+), 53 deletions(-)
 create mode 100644 tools/perf/feature-tests.mak

