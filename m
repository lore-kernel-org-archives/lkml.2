Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab1DYPWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 11:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab1DYPWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 11:22:10 -0400
Date: Mon, 25 Apr 2011 17:20:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] signal: retarget_shared_pending: consider
	shared/unblocked signals only
Message-ID: <20110425152040.GA14934@redhat.com>
References: <20110418134421.GA15951@redhat.com> <20110418134501.GC15951@redhat.com> <20110425105229.GE17734@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425105229.GE17734@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Tejun Heo wrote:
>
> On Mon, Apr 18, 2011 at 03:45:01PM +0200, Oleg Nesterov wrote:
> > -static void retarget_shared_pending(struct task_struct *tsk)
> > +static void retarget_shared_pending(struct task_struct *tsk, sigset_t *set)
>
> Hmm... @set?  Maybe a name which refelcts its purpose, say @target or
> @consider would be better?  Also, it would be really great to have
> docbook function comment describing the parameter.

OK... May be @which ? but I agree with any naming.


This series is already in -mm, I'd like to avoid another resend. So I'll
send another patch which addresses your comments on top of this series.

OK?

>  Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

Oleg.

