Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab0EGEVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 00:21:22 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35030 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab0EGEVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 00:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QBGWq40dNLqfz2+kWILnnDIcyGrTWYvBJAZYEnRe5jn55S9iGG3EyK75gtZWC/9tsS
         YqBMeFX5jKHklWMJv4vmzjsvOkCGCofcA54rwgRRyg9yRl7HFjQmBee3c8glwTm4HQn4
         ZW5VI1Nwe8DurQ/RzZML3S//M3IV4W/pUJPtA=
Date: Fri, 7 May 2010 06:21:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/9 - v2][RFC] tracing: Create class struct for events
Message-ID: <20100507042117.GD8069@nowhere>
References: <20100504034045.085822814@goodmis.org> <20100504034201.417959554@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504034201.417959554@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 11:40:46PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch creates a ftrace_event_class struct that event structs point to.
> This class struct will be made to hold information to modify the
> events. Currently the class struct only holds the events system name.
> 
> This patch slightly increases the size of the text as well as decreases
> the data size. The overall change is still a slight increase, but
> this change lays the ground work of other changes to make the footprint
> of tracepoints smaller.
> 
> With 82 standard tracepoints, and 616 system call tracepoints:
> 
>    text	   data	    bss	    dec	    hex	filename
> 5788186	1337252	9351592	16477030	 fb6b66	vmlinux.orig
> 5792282	1333796	9351592	16477670	 fb6de6	vmlinux.class
> 
> This patch also cleans up some stale comments in ftrace.h.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

