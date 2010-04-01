Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab0DARDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:03:16 -0400
Received: from sous-sol.org ([216.99.217.87]:44062 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755864Ab0DARDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:03:09 -0400
Date: Thu, 1 Apr 2010 10:02:30 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Roland Dreier <rdreier@cisco.com>, "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Peter Morreale <pmorreale@novell.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
Message-ID: <20100401170230.GW29241@sequoia.sous-sol.org>
References: <4BB3D90C.3030108@us.ibm.com> <adaeij0gj3a.fsf@roland-alpha.cisco.com> <4BB3FF03.7060400@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB3FF03.7060400@us.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Darren Hart (dvhltc@us.ibm.com) wrote:
> Roland Dreier wrote:
>>  > I'm looking at some adaptive spinning with futexes as a way to help
>>  > reduce the dependence on sched_yield() to implement userspace
>>  > spinlocks. Chris, I included you in the CC after reading your comments
>>  > regarding sched_yield() at kernel summit and I thought you might be
>>  > interested.
>>
>> I think you may have the wrong Chris.  Chris Wright wasn't at the most
>> recent kernel summit and I do have a vague recollection of Chris Mason
>> mentioning that Oracle developers found that sched_yield() performed
>> better than futexes + kernel scheduling.
>
> Oh bother, Sorry Chris! I even talked to Chris Wright about this already  
> in person and he told me I probably was looking for Chris Mason, and I  
> still got the last names crossed up!

No worries Darren, I happen to be interested in the topic too ;-)
(from KVM point of view, which has a slightly different take)
