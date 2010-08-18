Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0HRWSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 18:18:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39508 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0HRWSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 18:18:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Bernd Petrovitsch <bernd@sysprog.at>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL 0/1] perf/urgent fix
Date: Wed, 18 Aug 2010 19:18:17 -0300
Message-Id: <1282169898-28321-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

	Or perhaps apply it directly, as git.kernel.org is taking ages to
sync with master today...

Regards,

- Arnaldo

Kusanagi Kouichi (1):
  perf tools: Fix build error on read only source.

 tools/perf/Makefile          |   14 ++++++++++----
 tools/perf/feature-tests.mak |    2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

