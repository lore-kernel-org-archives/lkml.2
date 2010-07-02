Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab0GBMs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 08:48:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab0GBMs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 08:48:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [GIT PULL 0/1] perf/urgent fixes
Date: Fri,  2 Jul 2010 09:48:43 -0300
Message-Id: <1278074924-21998-1-git-send-email-acme@infradead.org>
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

Gui Jianfeng (1):
  perf tools: Fix find tids routine by excluding "." and ".."

 tools/perf/util/thread.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

