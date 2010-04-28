Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0D1X6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:58:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33321 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab0D1X57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:57:59 -0400
X-Authority-Analysis: v=1.1 cv=elpKMhBbP+pQyLZqL930WohJ6E0KICKd8OrLrcMNK78= c=1 sm=0 a=WIZP6gBhYTAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=BVTqTsO2fRvKcijHyJsA:9 a=MTRcYAG-H1nXlI_aM10vFI8_s7sA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 03/10][RFC] tracing: Convert TRACE_EVENT() to use the
 DECLARE_TRACE_DATA()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20100428203939.GD8591@Krystal>
References: <20100426195024.256424113@goodmis.org>
	 <20100426200241.938003192@goodmis.org>  <20100428203939.GD8591@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 28 Apr 2010 19:57:57 -0400
Message-ID: <1272499077.9739.85.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 16:39 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Switch the TRACE_EVENT() macros to use DECLARE_TRACE_DATA(). This
> > patch is done to prove that the DATA macros work. If any regressions
> > were to surface, then this patch would help a git bisect to localize
> > the area.
> > 
> > Once again this patch increases the size of the kernel.
> > 
> 
> As recommended in the earlier email:
> 
> It would make sense to just add the extra "callback_data" argument
> directly to DECLARE_TRACE(), modify the user (TRACE_EVENT) accordingly.
> And possibly create a TRACE_EVENT_NOARG() variant.

Are you suggesting to make DECLARE_TRACE() be...

#define DECLARE_TRACE(name, proto, args, data)

?

-- Steve


