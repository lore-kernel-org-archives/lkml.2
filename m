Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0DLW0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 18:26:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab0DLW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 18:26:42 -0400
X-Authority-Analysis: v=1.1 cv=fBoeiQUdCPFYkf/ogivDuUUJ8T/GUdptomsnt0mqf60= c=1 sm=0 a=7BGEWk__0CoA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=hGzw-44bAAAA:8 a=lH_R0VJiUEXIweXVz08A:9 a=Yi0e2MNiWNDS0Btbigdaa-aGhKYA:4 a=QEXdDO2ut3YA:10 a=dowx1zmaLagA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: TRACE_EVENT() declarations belong to include/trace/
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100412214511.GA2699@Krystal>
References: <20100412214511.GA2699@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 18:01:18 -0400
Message-ID: <1271109678.1866.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 17:45 -0400, Mathieu Desnoyers wrote:
> Hi,
> 
> Ranting about:
> 
> commit 1bf4af165050d90ea6659ffb2536ec8ca783aab5
> Author: Anton Blanchard <anton@samba.org>
> Date:   Mon Oct 26 18:47:42 2009 +0000
> 
>     powerpc: tracing: Add powerpc tracepoints for interrupt entry and exit
> 
> Why are there TRACE_EVENT() declarations in arch/powerpc/include/asm/trace.h for
> irq_entry/exit ?
> 
> What's so special about them that they cannot be put in linux/trace/ ?
> 
> I'm all for the trace_irq_entry/exit instrumentation, but I don't see any good
> in adding event declarations outside of include/trace/.


If there is any specific architecture data being recorded in the
TRACE_EVENT() macro, then it should be arch specific, but if not, then
it should go in  include/trace/

/me goes to look at the code.

-- Steve

