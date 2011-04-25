Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab1DYRDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:03:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab1DYRDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:03:21 -0400
Date: Mon, 25 Apr 2011 19:02:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] signal: retarget_shared_pending: consider
	shared/unblocked signals only
Message-ID: <20110425170200.GA18363@redhat.com>
References: <20110418134421.GA15951@redhat.com> <20110418134501.GC15951@redhat.com> <20110425105229.GE17734@mtj.dyndns.org> <20110425152040.GA14934@redhat.com> <20110425161951.GA30828@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425161951.GA30828@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Tejun Heo wrote:
>
> On Mon, Apr 25, 2011 at 05:20:40PM +0200, Oleg Nesterov wrote:
> > This series is already in -mm, I'd like to avoid another resend. So I'll
> > send another patch which addresses your comments on top of this series.
> >
> > OK?
>
> Why not route through the signal/ptrace tree?

I did these changes against the Linus's tree to simplify the review, and
because there are completely orthogonal to ptrace changes. Also, I like
very much the fact -mm has users/testers.

In fact, there are trivial conflicts with the ptrace branch. I think
ptrace should be flushed first, so I'll rebase this "sigprocmask" branch
when I address all comments.

Or do you think I should merge these changes into ptrace branch? I'd like
to keep them separate, but I am not sure if I should...

Oleg.

