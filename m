Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab0FUOWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:22:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34817 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab0FUOWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:22:38 -0400
X-Authority-Analysis: v=1.1 cv=w1shWbTWTAfAQ6jIUag4hBIbd8wqGnfzh/ne7nEp+Po= c=1 sm=0 a=W1W_y5r0NXcA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=iVGlj-kmZ1XtFoJacNoA:9 a=-KpUk65Ftz97Y2QTiE_2OgmKTZ0A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH v5 11/14] trace: uprobes trace_event interface
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100614083008.29068.56731.sendpatchset@localhost6.localdomain6>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
	 <20100614083008.29068.56731.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 21 Jun 2010 10:22:36 -0400
Message-ID: <1277130156.9181.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 14:00 +0530, Srikar Dronamraju wrote:

> +config UPROBE_EVENT
> +	depends on UPROBES
> +	bool "Enable uprobes-based dynamic events"
> +	select TRACING
> +	default y

Why is this default y?

-- Steve

> +	help
> +	  This allows the user to add tracing events on top of userspace dynamic
> +	  events (similar to tracepoints) on the fly via the traceevents interface.
> +	  Those events can be inserted wherever uprobes can probe, and record
> +	  various registers.
> +	  This option is required if you plan to use perf-probe subcommand of perf
> +	  tools on user space applications.
> +
>  endif # FTRACE
>  
>  

