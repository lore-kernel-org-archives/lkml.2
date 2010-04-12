Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab0DLXZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:25:27 -0400
Received: from ozlabs.org ([203.10.76.45]:48280 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0DLXZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:25:26 -0400
Date: Tue, 13 Apr 2010 09:24:56 +1000
From: Anton Blanchard <anton@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: TRACE_EVENT() declarations belong to include/trace/
Message-ID: <20100412232456.GI11751@kryten>
References: <20100412214511.GA2699@Krystal>
 <20100412220451.GG8285@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412220451.GG8285@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Frederic,

> If this is to trace all irqs, then it seems to me the wrong way.
> We already have generic irq_handler_entry and irq_handler_exit trace events.
> 
> May be those in powerpc are here to get the spurious irqs by computing
> a diff between generic and arch irq events? In which case
> it would be better to get dedicated spurious irq tracepoints.

The number of spurious irqs are not interesting - we track them in
/proc/interrupts. The duration of the disturbances are, and they were big
enough for people to see them in certain HPC loops.

Anton
