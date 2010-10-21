Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab0JUCnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:43:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53751 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab0JUCnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:43:07 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=FbgsWPMclSkA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=n2g5nAbsjIsqwTYnelAA:9 a=o4AV6MlfD-K4_uWNvgRS3TkmsuYA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101021024233.530237054@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Oct 2010 22:42:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: Minor fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (2):
      tracing: Prevent unloadable modules from using trace_bprintk()
      tracing: Do not limit the size of the number of CPU buffers

----
 include/linux/kernel.h      |   21 +++++++++++++++++++--
 kernel/trace/trace.c        |    8 ++------
 kernel/trace/trace_printk.c |    2 ++
 3 files changed, 23 insertions(+), 8 deletions(-)
