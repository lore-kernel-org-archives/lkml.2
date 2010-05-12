Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0ELPgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:36:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39519 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab0ELPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:36:38 -0400
X-Authority-Analysis: v=1.1 cv=QBaIlYAip0cLYvdi/Wu3On4+kilSXYulM+a9j4asJ0c= c=1 sm=0 a=zNANCjgXmV0A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=d8JmqXib8SAVGlxt_gkA:9 a=HqV7XU7sDkJpV1NgSudxZu7MhyYA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC] PyTimechart
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
       arjan@infradead.org, ziga.mahkovec@gmail.com
In-Reply-To: <20100512144811.GA5405@nowhere>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
	 <20100511213625.GD5422@nowhere>
	 <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com>
	 <20100512144811.GA5405@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 12 May 2010 11:36:36 -0400
Message-ID: <1273678596.27703.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 16:48 +0200, Frederic Weisbecker wrote:
> On Wed, May 12, 2010 at 03:37:27PM +0200, Pierre Tardy wrote:

> But we don't yet support trace_printk in perf. May be we could wrap
> them in trace events.

Hmm, do we really want to do that?

We really need to get the perf and ftrace trace buffers combined. I
understand why perf chose to do the mmap buffers for the counting, but
for live streaming, it is very inefficient compared to splice.

I would hate to add more duplicate code to have perf support
trace_printk().

-- Steve



