Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab0FHRhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:37:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16495 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0FHRhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:37:14 -0400
Date: Tue, 8 Jun 2010 10:35:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: Re: Tracing configuration review
Message-Id: <20100608103517.ac380ad4.randy.dunlap@oracle.com>
In-Reply-To: <1274821799.9346.17.camel@cndougla-ubuntu>
References: <1274815906.9757.83.camel@cndougla-ubuntu>
	<20100525201259.GA5370@nowhere>
	<1274821799.9346.17.camel@cndougla-ubuntu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090203.4C0E7F85.00F0:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 17:09:59 -0400 Chase Douglas wrote:

> On Tue, 2010-05-25 at 22:13 +0200, Frederic Weisbecker wrote:
> > On Tue, May 25, 2010 at 03:31:46PM -0400, Chase Douglas wrote:
> > > The following options are what I am looking to set for our x86
> > > configurations. I've only included those that I am not 100% sure of.
> > > Comments are what I could gather from documentation and Kconfig, but
> > > they may not be accurate:
> 
> <snip>
> 
> > > # CONFIG_SCHED_TRACER is not set (headed for deprecation?)
> > 
> > 
> > We want to deprecate it in the long term, but for now we
> > don't have any replacement. Cool for RT latency tracing.
> 
> I thought that the functionality is the same as what you get by:
> 
> echo 1 > (debufs)/tracing/events/sched/enable
> 
> > > CONFIG_KSYM_TRACER=y (no performance impact by default)
> > 
> > 
> > IMO, it is deprecated. The perf interface is much more powerful and flexible.
> > Prasad, do you agree if I remove this ftrace plugin?
> 
> If there isn't any use in enabling it due to perf's features, then we
> can turn it off. However, if there's any use to be gained by this over
> perf's features, then I'd prefer to leave it on. Thoughts?
> 
> 
> > > CONFIG_WORKQUEUE_TRACER=y (no performance impact by default)
> > 
> > 
> > In the way for deprecation.
> 
> Is this like the KMEM_TRACER where trace events have superseded it?


Hi Chase,

Would you mind sharing your final tracing config options?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
