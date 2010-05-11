Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab0EKTAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:00:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48253 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab0EKTAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:00:11 -0400
X-Authority-Analysis: v=1.1 cv=RZg5C6NCKrCZril9sGGnsuGk01/OiP2z3O3lo0hXATg= c=1 sm=0 a=SSFxOwRvCusA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=FgXdjwP_gh_qW8Yl9eYA:9 a=c4RKTT7eNcNId07mcIxCe7WR1BcA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 10/10 -v3][RFC] tracing: Combine event filter_active
 and enable into single flags field
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20100511140557.GA29543@Krystal>
References: <20100511030020.837892321@goodmis.org>
	 <20100511030911.927339838@goodmis.org> <20100511033026.GA28162@Krystal>
	 <1273584628.22438.4501.camel@gandalf.stny.rr.com>
	 <20100511140557.GA29543@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 11 May 2010 15:00:09 -0400
Message-ID: <1273604409.27703.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 10:05 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > 
> > The comment should also be in Documentation, not here, since it would
> > affect users more than the developers.
> 
> Typically, locking-related information belongs to comments close to the
> definition. I'm not sure why you say it affects users at all.

I thought you were concerned about changes to the filter not taking
affect immediately. But, yeah, if you are worried that developers should
know that the read value may change, then sure, comment at the code.

-- Steve


