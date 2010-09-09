Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab0IIX5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:57:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:33360 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab0IIX5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 19:57:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Davidlohr Bueso <dave@gnu.org>, Jovi Zhang <bookjovi@gmail.com>
Subject: [GIT PULL 0/1] perf/urgent symbols fix
Date: Thu,  9 Sep 2010 20:56:53 -0300
Message-Id: <1284076614-4154-1-git-send-email-acme@infradead.org>
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

Jovi Zhang (1):
  perf symbols: Fix multiple initialization of symbol system

 tools/perf/util/symbol.c |    7 +++++++
 tools/perf/util/symbol.h |    3 ++-
 2 files changed, 9 insertions(+), 1 deletions(-)

