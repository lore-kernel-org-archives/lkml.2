Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0DACEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:04:00 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48093 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab0DACD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:03:57 -0400
Message-ID: <4BB3FF03.7060400@us.ibm.com>
Date: Wed, 31 Mar 2010 19:03:47 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: "lkml\, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Peter Morreale <pmorreale@novell.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com> <adaeij0gj3a.fsf@roland-alpha.cisco.com>
In-Reply-To: <adaeij0gj3a.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > I'm looking at some adaptive spinning with futexes as a way to help
>  > reduce the dependence on sched_yield() to implement userspace
>  > spinlocks. Chris, I included you in the CC after reading your comments
>  > regarding sched_yield() at kernel summit and I thought you might be
>  > interested.
> 
> I think you may have the wrong Chris.  Chris Wright wasn't at the most
> recent kernel summit and I do have a vague recollection of Chris Mason
> mentioning that Oracle developers found that sched_yield() performed
> better than futexes + kernel scheduling.

Oh bother, Sorry Chris! I even talked to Chris Wright about this already 
in person and he told me I probably was looking for Chris Mason, and I 
still got the last names crossed up!

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
