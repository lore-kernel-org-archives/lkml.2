Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab0GPSIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:08:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:49045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273Ab0GPSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:08:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL 0/1] perf/urgent fixes
Date: Fri, 16 Jul 2010 15:07:46 -0300
Message-Id: <1279303667-27764-1-git-send-email-acme@infradead.org>
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

Gui Jianfeng (1):
  perf symbols: Fix directory descriptor leaking

 tools/perf/util/symbol.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

