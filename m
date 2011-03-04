Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703Ab1CDQfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:35:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1CDQfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:35:10 -0500
Date: Fri, 4 Mar 2011 17:26:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304162618.GA24871@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org> <20110303173422.GA27960@redhat.com> <20110304084441.GB20499@htj.dyndns.org> <20110304160151.GA23553@redhat.com> <20110304161541.GV20499@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304161541.GV20499@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Fri, Mar 04, 2011 at 05:01:51PM +0100, Oleg Nesterov wrote:
> > What I meant, I think the exact details can be discussed separately.
> > Say, personally I'd prefer 2 different requests, ATTACH && INTERUPT,
> > but I think this is very minor, and I agree with everything as long
> > as user-space developers do not object. I just tried to avoid the
> > discussion of the "cosmetic" details at this point.
>
> Understood.  One thing tho.  Do you think having ATTACH_NO_STOP would
> be better?

No, I don't think so. More precisely, I simply do not know, we should
probably ask Jan.

But. from the previous discussions, gdb seems to need
PTRACE_O_ATTACH_NEW_THREADS_AND_DO_NOT_STOP. Because gdb simply do not
want to know about the new thread, until it does something "interesting".
However this leads to other questions.

Oleg.

