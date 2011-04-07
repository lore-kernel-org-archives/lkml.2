Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1DGScJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:32:09 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56929 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754793Ab1DGScH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:32:07 -0400
Date: Thu, 7 Apr 2011 14:32:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Huang Ying <ying.huang@intel.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "lenb@kernel.org" <lenb@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: About lock-less data structure patches
Message-ID: <20110407183206.GB6104@Krystal>
References: <BLU0-SMTP52616BFA7ABB7E8E73E8396BC0@phx.gbl> <4D93DB49.3060205@intel.com> <20110401213748.GA26543@Krystal> <4D96AEAE.2010800@intel.com> <20110404155328.GA13390@Krystal> <BANLkTin3XpOnnqWcu-bsUCJ_6JaYcBkJkg@mail.gmail.com> <20110405044227.GA20013@Krystal> <BANLkTinLH=s419RVQXSUTjBSdH0XjdpZWg@mail.gmail.com> <20110406014824.GB32321@Krystal> <4D9D1DF0.6030704@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9D1DF0.6030704@intel.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:30:58 up 134 days, 23:34,  4 users,  load average: 0.18, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang Ying (ying.huang@intel.com) wrote:
> On 04/06/2011 09:48 AM, Mathieu Desnoyers wrote:
> > * huang ying (huang.ying.caritas@gmail.com) wrote:
> [snip]
> >>>>
> >>>> OK.  I will change the comments, adding these semantics explanation.
> >>>> The user should be warned :)
> >>>
> >>> Yes, that makes sense. After this generalization step, if you're ok with
> >>> this, we could aim at moving the implementation from a stack to a queue
> >>> and provide fifo semantic rather than lifo, so that other users (e.g.
> >>> call_rcu in the kernel) can start benefiting from it.
> >>
> >> I think that is good to move from stack to queue.
> >>
> >> I will send out changed lock-less data structure patchset soon.  And
> >> we can continue to work on the new lock-less queue at the same time.
> > 
> > Sounds like a very good plan! Thanks!
> 
> Maybe you can send out your lock-less queue patches, so we can work on that.

Yep, let's wait until your implementation is finalized and merged, and
then ping me again so I can cook up a RFC patch turning llist into a
queue, if it's OK with you.

Thanks,

Mathieu

> 
> Best Regards,
> Huang Ying

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
