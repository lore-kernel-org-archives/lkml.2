Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0DLWY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 18:24:58 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60968 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753592Ab0DLWY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 18:24:57 -0400
Date: Mon, 12 Apr 2010 18:24:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>
Subject: [RELEASE] LTTng 0.210 for kernel 2.6.33.2
Message-ID: <20100412222455.GA3086@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:19:49 up 80 days, 56 min,  2 users,  load average: 0.01, 0.04,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

LTTng 0.210 fixes LTTng powerpc support. Commit
1bf4af165050d90ea6659ffb2536ec8ca783aab5 interestingly added TRACE_EVENT()
definitions outside of include/trace/, which got out of my attention span.

I'm just reverting that stuff in the LTTng tree. I already instrument
kernel/irq/handle.c:handle_IRQ_event(), which seems like the sane arch-agnostic
way to do it.

Let's hope this mess gets addressed directly in mainline. I recommend to merge
useful parts from arch/powerpc/include/asm/trace.h into include/trace/ and kill
this header file.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
