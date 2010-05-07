Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab0EGPn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:43:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33576 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab0EGPnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:43:55 -0400
X-Authority-Analysis: v=1.1 cv=nrqrmdtKPnrEe5McJVoaEKFzY/lexCxOe+Stj/aSkNs= c=1 sm=0 a=8LHCb4_oiB0A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=e2nmDqdt3TG2yUAM7jUA:9 a=-LqdC_mQsFEXL7OLkHJ_MnwCsi0A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/9 - v2][RFC] tracing: Remove per event trace
 registering
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100507153158.GB15267@Krystal>
References: <20100504034045.085822814@goodmis.org>
	 <20100504034202.282030521@goodmis.org> <20100507042025.GC8069@nowhere>
	 <20100507145438.GB29573@Krystal>
	 <1273245128.22438.160.camel@gandalf.stny.rr.com>
	 <20100507153158.GB15267@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 07 May 2010 11:43:51 -0400
Message-ID: <1273247031.22438.198.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 11:31 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > You are asking to add a check that I can not see helping. The only way
> > to add a check, is to use the automated process to check the automation.
> > If the automated process fails, it is very likely the check will also be
> > broken and will not catch the bug either.
> 
> Tell me where to fetch the git head, I'll add it myself. ;)

It was posted in the 0/9 patch. Although I am modifying it now to
include the latest changes.

-- Steve


