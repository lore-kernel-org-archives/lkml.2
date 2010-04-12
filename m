Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0DLVpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:45:15 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60901 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753702Ab0DLVpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:45:13 -0400
Date: Mon, 12 Apr 2010 17:45:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, Anton Blanchard <anton@samba.org>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: TRACE_EVENT() declarations belong to include/trace/
Message-ID: <20100412214511.GA2699@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:38:45 up 80 days, 15 min,  2 users,  load average: 0.00, 0.04,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ranting about:

commit 1bf4af165050d90ea6659ffb2536ec8ca783aab5
Author: Anton Blanchard <anton@samba.org>
Date:   Mon Oct 26 18:47:42 2009 +0000

    powerpc: tracing: Add powerpc tracepoints for interrupt entry and exit

Why are there TRACE_EVENT() declarations in arch/powerpc/include/asm/trace.h for
irq_entry/exit ?

What's so special about them that they cannot be put in linux/trace/ ?

I'm all for the trace_irq_entry/exit instrumentation, but I don't see any good
in adding event declarations outside of include/trace/.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
