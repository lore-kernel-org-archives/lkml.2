Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758Ab1CDQK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:10:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759618Ab1CDQK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:10:56 -0500
Date: Fri, 4 Mar 2011 17:01:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304160151.GA23553@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org> <20110303173422.GA27960@redhat.com> <20110304084441.GB20499@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304084441.GB20499@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Tejun Heo wrote:
>
> Hey, Oleg.
>
> On Thu, Mar 03, 2011 at 06:34:22PM +0100, Oleg Nesterov wrote:
> > > P4. PTRACE_SEIZE
> >
> > This is the new request. You know, I'd like to discuss the details
> > later and separately. Actually, I think the user-space developers
> > should participate and tell what they need. As for me, I certainly
> > agree that SIGSTOP from PTRACE_ATTACH is very wrong, and it is very
> > bad that gdb has to send SIGSTOP if it wants to stop the tracee.
> > IOW, I agree that something like this is needed and useful. In
> > particular,
>
> While discussing is good, I'd like to keep things slightly more
> driven.  I think, as anything else, there's a balance to hit between
> discussing and just pushing things forward.  We did fair amount of
> discussion past two+ months and well I think it's about time to push
> forward.
>
> By now gdb/strace ppl should be aware of what's going on, right?

Yes. I think I wasn't clear.

What I meant, I think the exact details can be discussed separately.
Say, personally I'd prefer 2 different requests, ATTACH && INTERUPT,
but I think this is very minor, and I agree with everything as long
as user-space developers do not object. I just tried to avoid the
discussion of the "cosmetic" details at this point.

> So,
> if you guys have something on mind w.r.t. kernel behavior, please
> share, but I won't wait for some discussion elsewhere

No. I agree, this should be discussed here.

Oleg.

