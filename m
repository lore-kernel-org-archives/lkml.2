Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0GVUhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:37:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:53072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab0GVUhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:37:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Conny Seidel <conny.seidel@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Thu, 22 Jul 2010 17:36:55 -0300
Message-Id: <1279831017-26967-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf annotate: Fix handling of goto labels that are valid hex numbers

Conny Seidel (1):
  perf tools: Fix fallback to cplus_demangle() when bfd_demangle() is
    not available

 tools/perf/Makefile    |   40 +++++++++++++++++++++-------------------
 tools/perf/util/hist.c |    8 ++++++--
 2 files changed, 27 insertions(+), 21 deletions(-)

