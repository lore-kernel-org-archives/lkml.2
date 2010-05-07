Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab0EGM6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 08:58:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0EGM6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 08:58:01 -0400
X-Authority-Analysis: v=1.1 cv=OMZqYO3L41gFG4eI735GctFZkIqa2t9YKv4cWfI71LE= c=1 sm=0 a=q_jxKnJxyX0A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=f9B20GKQXyT-MpOgTEAA:9 a=etGgw1xQngRI5-p8788RoZiBhfsA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 4/9 - v2][RFC] tracing: Move fields from event to class
 structure
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20100507044914.GE8069@nowhere>
References: <20100504034045.085822814@goodmis.org>
	 <20100504034202.506915822@goodmis.org>  <20100507044914.GE8069@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 07 May 2010 08:57:56 -0400
Message-ID: <1273237076.22438.74.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 06:49 +0200, Frederic Weisbecker wrote:
> On Mon, May 03, 2010 at 11:40:49PM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>

> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Now I need to recover from my CPP headache before reviewing
> this set further ;)
> 

I know how you feel. Actually writing CPP takes your brain away from the
ability to write documentation, hence my lack of it ;-)

-- Steve


