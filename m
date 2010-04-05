Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0DEP00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:26:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:54116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab0DEP0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:26:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/2] perf: Usability improvements
Date: Mon,  5 Apr 2010 12:26:14 -0300
Message-Id: <1270481176-20659-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

	Please consider pulling from the "perf" branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6

Arnaldo Carvalho de Melo (2):
  perf TUI: Show filters on the title and add help line about how to zoom out
  perf TUI: Move "Yes" button to before "No"

 tools/perf/util/newt.c |   98 +++++++++++++++++++++++++++++++++--------------
 1 files changed, 69 insertions(+), 29 deletions(-)

