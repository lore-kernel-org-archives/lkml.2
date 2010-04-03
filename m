Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0DCToZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 15:44:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:55165 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab0DCToO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 15:44:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/1] perf newt: Zoom operations
Date: Sat,  3 Apr 2010 16:44:07 -0300
Message-Id: <1270323848-28094-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

	Please consider pulling from the "perf" branch in:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6

Best Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf newt: Add a " "Zoom into foo.so DSO" and reverse operations

 tools/perf/util/newt.c |  119 +++++++++++++++++++++++++++++++++++------------
 tools/perf/util/sort.h |    3 +-
 2 files changed, 90 insertions(+), 32 deletions(-)

