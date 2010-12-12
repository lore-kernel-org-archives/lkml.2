Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab0LLPRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 10:17:12 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40814 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab0LLPRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 10:17:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        2nddept-manager@sdl.hitachi.co.jp,
        Francis Moreau <francis.moro@gmail.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Franck Bui-Huu <vagabon.xyz@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Sun, 12 Dec 2010 13:16:52 -0200
Message-Id: <1292167014-20936-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Franck Bui-Huu (2):
  perf probe: Fix use of kernel image path given by 'k' option
  perf symbols: Stop using vmlinux files with no symbols

 tools/perf/builtin-probe.c    |    5 +++++
 tools/perf/util/probe-event.c |   15 ++++++++++++---
 tools/perf/util/symbol.c      |    4 ++--
 tools/perf/util/symbol.h      |    2 ++
 4 files changed, 21 insertions(+), 5 deletions(-)

