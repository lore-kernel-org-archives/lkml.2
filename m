Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0LBSqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:46:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35785 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab0LBSqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:46:46 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=siQLTssk8YkA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=Ell4V0STDsV3GRc9Xd4A:9 a=2gCJJ1ronzoVixAOUYcA:7 a=93uUGcNM9x-HDXZtJyLlvWg5J1QA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101202184612.129218522@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 13:46:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL][2.6.37] tracing: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


John Reiser (1):
      ftrace: Have recordmcount honor endianness in fn_ELF_R_INFO

Peter Zijlstra (1):
      scripts/tags.sh: Add magic for trace-events

Slava Pestov (1):
      tracing: Fix panic when lseek() called on "trace" opened for writing

----
 kernel/trace/trace.c   |   10 +++++++++-
 scripts/recordmcount.h |    2 +-
 scripts/tags.sh        |    4 +++-
 3 files changed, 13 insertions(+), 3 deletions(-)
