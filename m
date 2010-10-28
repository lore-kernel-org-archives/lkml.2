Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab0J1OF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:05:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51536 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774Ab0J1OFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:05:54 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=RvhZAA5o1bIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=nCMKyIvWXTZ6Bg5DRb0A:9 a=7LKmeJ7lKIVplFRuhduTNn8_5-IA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101028140512.441043850@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 28 Oct 2010 10:05:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] ftrace: recordmcount.c updates for MIPS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/mips tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/mips


John Reiser (1):
      ftrace/MIPS: Add MIPS64 support for C version of recordmcount

Wu Zhangjin (2):
      ftrace/MIPS: Add module support for C version of recordmcount
      ftrace/MIPS: Enable C Version of recordmcount

----
 arch/mips/Kconfig      |    1 +
 scripts/recordmcount.c |   44 ++++++++++++++++++++++++
 scripts/recordmcount.h |   86 +++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 126 insertions(+), 5 deletions(-)
