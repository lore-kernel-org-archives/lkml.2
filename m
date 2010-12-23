Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0LWM4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 07:56:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47691 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0LWM4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 07:56:14 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=heD8I4ohhdAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=NdegZAw4AoZ6PcTxkKsA:9 a=b291zD9zMvZIjlu5yPX4H8cVTW0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4D13114D.5060709@cn.fujitsu.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	 <4D083900.1050801@cn.fujitsu.com>
	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>
	 <4D0877D2.10000@cn.fujitsu.com>
	 <1292425462.5015.1895.camel@gandalf.stny.rr.com>
	 <4D13114D.5060709@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Dec 2010 07:56:10 -0500
Message-ID: <1293108970.22802.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 17:07 +0800, Lai Jiangshan wrote:
> On 12/15/2010 11:04 PM, Steven Rostedt wrote:
> > On Wed, 2010-12-15 at 16:09 +0800, Lai Jiangshan wrote:
> > 
> > Some English updates.
> 
> Updated, Thank you very much.
> 

Note, I've been working all week on a port for -rt. It required some
clean ups, but as I finished (last week), I keep hitting a "hung task"
when running dbench in a loop over night. I spent most the week trying
to debug it. But I'm starting to think this is something to do with -rt
and not your patch. So I'll be posting my patches later today.

-- Steve


