Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab0HQVwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:52:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab0HQVwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:52:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Bernd Petrovitsch <bernd@sysprog.at>, Ingo Molnar <mingo@elte.hu>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL 0/1] perf/urgent fixes
Date: Tue, 17 Aug 2010 18:52:37 -0300
Message-Id: <1282081958-22323-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Bernd Petrovitsch (1):
  perf tools: Fix build on POSIX shells

 tools/perf/Makefile |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

