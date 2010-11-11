Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab0KKVmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:42:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab0KKVmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:42:00 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=89bJTBtopsAA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=Cj8vSp6T_1oWnt8ar9YA:9 a=gZ_YrxLYKk5SE8-cIrw7Q1PLBAEA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101111214111.675303594@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 11 Nov 2010 16:41:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [PATCH][2.6.37] tracing: fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Steven Rostedt (2):
      tracing: Fix module use of trace_bprintk()
      tracing: Force arch_local_irq_* notrace for paravirt

----
 arch/x86/include/asm/paravirt.h |   10 +++++-----
 kernel/module.c                 |   12 ++++++++++++
 2 files changed, 17 insertions(+), 5 deletions(-)
