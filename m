Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0K2R4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:56:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:58367 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab0K2R4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:56:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Ming Lei <tom.leiming@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 0/2] *** SUBJECT HERE ***
Date: Mon, 29 Nov 2010 15:56:10 -0200
Message-Id: <1291053372-13592-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** BLURB HERE ***

Arnaldo Carvalho de Melo (1):
  perf symbols: Fix kallsyms kernel/module map splitting

Ming Lei (1):
  perf symbols: Figure out start address of kernel map from kallsyms

 tools/perf/util/symbol.c |   59 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 53 insertions(+), 6 deletions(-)

