Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab1DZTrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:47:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1DZTrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:47:07 -0400
Date: Tue, 26 Apr 2011 21:45:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] signal: retarget_shared_pending: consider
	shared/unblocked signals only
Message-ID: <20110426194536.GA7590@redhat.com>
References: <20110418134421.GA15951@redhat.com> <20110418134501.GC15951@redhat.com> <20110425105229.GE17734@mtj.dyndns.org> <20110425152040.GA14934@redhat.com> <20110425161951.GA30828@mtj.dyndns.org> <20110425170200.GA18363@redhat.com> <BANLkTi=oksQFYtyS1+RA5c_4E22yjik90g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=oksQFYtyS1+RA5c_4E22yjik90g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/25, Tejun Heo wrote:
> Hey,
>
> On Mon, Apr 25, 2011 at 7:02 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > I did these changes against the Linus's tree to simplify the review, and
> > because there are completely orthogonal to ptrace changes. Also, I like
> > very much the fact -mm has users/testers.
> >
> > In fact, there are trivial conflicts with the ptrace branch. I think
> > ptrace should be flushed first, so I'll rebase this "sigprocmask" branch
> > when I address all comments.
> >
> > Or do you think I should merge these changes into ptrace branch? I'd like
> > to keep them separate, but I am not sure if I should...
>
> I don't know.  Signal/ptrace is closely coupled and you would be
> reviewing/acking anyway, and linux-next has some test coverage (I
> don't know how much but...), so I think it would be least painful to
> route these together.  You can create separate topic branches for
> signal and ptrace but I don't think that's required.  Anyways, yeah,
> if there's no objection, I think it would be best to route these
> together with the ptrace changes.  The conflicts wouldn't be trivial
> and for a reason.

OK. I tried to update my branch to address the comments from you and
Matt, but I got lost inside the git-learning-curve. Will do tomorrow.

Until then, could you review the updated version of the new changes
we discussed yesterday? (will send in a minute).

Oleg.

