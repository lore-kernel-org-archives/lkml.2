Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab0EYQOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:14:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab0EYQOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:14:00 -0400
X-Authority-Analysis: v=1.1 cv=muTmBHIsIIrvj5np50lvqqEF3x9MmSj/zDSU9q1ni6E= c=1 sm=0 a=9wW1gReiNcoA:10 a=Lw_SFsgOoS4A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=pJx0_GCABUUWnW2MjTsA:9 a=nDPFn_tPnV0tMhOqdsKOvY11bSsA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100525161259.568803673@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 25 May 2010 12:12:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] ring-buffer: Some minor fixes for the latest changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (2):
      ring-buffer: Reset "real_end" when page is filled
      ring-buffer: Move zeroing out excess in page to ring buffer code

----
 kernel/trace/ring_buffer.c |   19 +++++++++++++++++--
 kernel/trace/trace.c       |    6 ------
 2 files changed, 17 insertions(+), 8 deletions(-)
