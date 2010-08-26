Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0HZAH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 20:07:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:48561 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0HZAH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 20:07:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/6] perf/core new features and improvements
Date: Wed, 25 Aug 2010 21:07:26 -0300
Message-Id: <1282781246-8782-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf hists: Fix hist_entry__init_have_children
  perf hists browser: replace rb_first() != NULL by !RB_EMPTY_ROOT()
  perf hists browser: Init the has_children fields just once
  perf hists browser: Introduce "expand/collapse all callchains" action

Srikar Dronamraju (1):
  perf symbols: List symbols in a dso in ascending name order

Tom Zanussi (1):
  perf tools: Fix linking errors with --as-needed flag

 tools/perf/Makefile                 |   21 ++++--
 tools/perf/util/symbol.c            |   14 ++++
 tools/perf/util/symbol.h            |    1 +
 tools/perf/util/ui/browsers/hists.c |  139 +++++++++++++++++++++++++++++------
 4 files changed, 145 insertions(+), 30 deletions(-)

