Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0DDBlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 21:41:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab0DDBkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 21:40:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] perf newt: Zoom operations
Date: Sat,  3 Apr 2010 22:40:48 -0300
Message-Id: <1270345250-4833-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from the "perf" branch in:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6

Best Regards,

Arnaldo Carvalho de Melo (2):
  perf newt: Add a "Zoom into foo.so DSO" and reverse operations
  perf TUI: Add a "Zoom into COMM(PID) thread" and reverse operations

 tools/perf/util/newt.c |  185 ++++++++++++++++++++++++++++++++++++++++--------
 tools/perf/util/sort.h |   10 ++-
 2 files changed, 162 insertions(+), 33 deletions(-)

