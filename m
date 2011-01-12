Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1ALRFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:05:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1ALRFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:05:36 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=3KrOCe59Vw4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=RiWFUA6wh9IC3PqLYXAA:9 a=-UOWRHc9g_cv5Y1BTq_T0E6rT8MA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH V3] rtmutex: ensure only the top waiter or higher
 priority task can take the lock and remove unrelated boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1294851864.26623.373.camel@gandalf.stny.rr.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	 <4D083900.1050801@cn.fujitsu.com>
	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>
	 <4D130D23.1040309@cn.fujitsu.com>
	 <1294851790.26623.372.camel@gandalf.stny.rr.com>
	 <1294851864.26623.373.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 12 Jan 2011 12:05:34 -0500
Message-ID: <1294851934.26623.374.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 12:04 -0500, Steven Rostedt wrote:
> On Wed, 2011-01-12 at 12:03 -0500, Steven Rostedt wrote:
> > On Thu, 2010-12-23 at 16:49 +0800, Lai Jiangshan wrote:
> > > In current rtmutex, the pending owner may be boosted by the tasks
> > > in the rtmutex's waitlist when the pending owner is deboosted
> > > or a task in the waitlist is boosted. This boosting is unrelated,
> > > because the pending owner does not really take the rtmutex.
> > > It is not reasonable.
> > 
> > Hi Lai,
> > 
> > Your patch looks like it is proving itself in -rt (after I fixed a bunch
> > of -rt stuff to get your stuff working ;).
> > 
> > Could you repost your patch with the following removed:
> 
> Oh, and you can add:
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 

Actually this would be more appropriate:

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


