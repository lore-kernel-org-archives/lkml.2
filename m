Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1HDO5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:57:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53278 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab1HDO5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:57:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/4] perf/core improvements and fixes
Date: Thu,  4 Aug 2011 11:57:14 -0300
Message-Id: <1312469838-2884-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

	I still need to comb more for patches sent while I was away,
the ones I checked you already merged, thanks.

Regards,

- Arnaldo


Arnaldo Carvalho de Melo (3):
  perf evlist: Introduce 'disable' method
  perf python: Add PERF_RECORD_{LOST,READ,SAMPLE} routine tables
  perf report: Use ui__warning in some more places

Han Pingtian (1):
  perf buildid-cache: Zero out buffer of filenames when adding/removing
    buildid

 tools/perf/builtin-record.c |   19 +------
 tools/perf/builtin-report.c |   15 +++---
 tools/perf/util/evlist.c    |   13 +++++
 tools/perf/util/evlist.h    |    2 +
 tools/perf/util/header.c    |    8 ++--
 tools/perf/util/python.c    |  115 +++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 140 insertions(+), 32 deletions(-)

