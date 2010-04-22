Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab0DVTC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:02:28 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54351 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab0DVTC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:02:27 -0400
Date: Fri, 23 Apr 2010 00:32:08 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Mike Chan <mike@android.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Salman <sqazi@google.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-pm@lists.linux-foundation.org, arjan@infradead.org,
       csadler@google.com, ranjitm@google.com, kenchen@google.com,
       dawnchen@google.com
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
Message-ID: <20100422190208.GD10750@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
 <1271317886.32749.69.camel@laptop>
 <v2v8bb80c381004211832o88258fdez8e640ad9a45d11c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <v2v8bb80c381004211832o88258fdez8e640ad9a45d11c0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Chan <mike@android.com> [2010-04-21 18:32:22]:

> On Thu, Apr 15, 2010 at 12:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-04-13 at 17:08 -0700, Salman wrote:
> >> As we discussed earlier this year, Google has an implementation that it
> >> would like to share.  I have finally gotten around to porting it to
> >> v2.6.33 and cleaning up the interfaces.  It is provided in the following
> >> messages for your review.  I realize that when we first discussed this
> >> idea, a lot of ideas were presented for enhancing it.  Thanks alot for
> >> your suggestions.  I haven't gotten around to implementing any of them.
> >
> > .33 is way too old to submit patches against.
> >
> > That said, I really really dislike this approach, I would much rather
> > see it tie in with power aware scheduling.
> 
> I may have missed this on lkml but are there any on-going community
> efforts to power aware scheduling?

Yes, mostly in power aware task placement and task consolidation in
large SMP systems and also some timer consolidation to improve low
power idle residency.

There are some tuning and optimizations in cpuidle governor that is
related to power management but not core scheduler.

As Peter mentioned, most of them may not apply to uni processor
systems.

--Vaidy
