Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab0FJQSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:18:44 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:48047 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907Ab0FJQSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:18:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAN+oEExGGOJc/2dsb2JhbACeXHK+b4UYBA
Date: Thu, 10 Jun 2010 12:13:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 03/13] jump label v9: x86 support
Message-ID: <20100610161339.GA20448@Krystal>
References: <cover.1276116186.git.jbaron@redhat.com> <c837d1a0a380030a4ea61acbcf0183518675a8ee.1276116186.git.jbaron@redhat.com> <1276171930.2077.200.camel@twins> <20100610121440.GA20130@elte.hu> <20100610150422.GA3923@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100610150422.GA3923@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:12:21 up 64 days,  2:05,  2 users,  load average: 0.65, 0.25,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Thu, Jun 10, 2010 at 02:14:40PM +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
> > > > +       select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
> > > 
> > > That deserves a comment somewhere, it basically makes OPTIMIZE_FOR_SIZE 
> > > useless...
> > 
> > Hm, we need more than a comment for that - distros enable CC_OPTIMIZE_FOR_SIZE 
> > all the time, for the massive kernel image (and hotpath cache footprint) 
> > savings. Is this fixable?
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> 
> When I tested 'jump label' with CC_OPTIMIZE_FOR_SIZE, I saw a small
> performance drop , b/c there is less block re-ordering happening.

Is this a performance drop compared to a jump-label-less kernel or
compared to -O2 kernel compiled with jump labels ? Or both ?

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
