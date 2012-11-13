Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992434Ab2KNVhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 16:37:10 -0500
Received: from ozlabs.org ([203.10.76.45]:53429 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab2KNVhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 16:37:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <ben@decadent.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Missing signoff for 'module: fix out-by-one error in kallsyms'
In-Reply-To: <1352775711.16264.96.camel@deadeye.wl.decadent.org.uk>
References: <1352775711.16264.96.camel@deadeye.wl.decadent.org.uk>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 13 Nov 2012 18:23:21 +1030
Message-ID: <87ip9a0wi6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:

> This doesn't have anyone's Signed-off-by:
>
> commit 59ef28b1f14899b10d6b2682c7057ca00a9a3f47
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Thu Oct 25 10:49:25 2012 +1030
>
>     module: fix out-by-one error in kallsyms
>
> It's a bit late to fix it now, but maybe some kind of an automatic check
> for this would be a good idea.
>
> Rusty, can I have your signoff for stable?

That is weird, but you're right.  I changed workflow recently, and it's
had a few nasty side-effects :(

That was supposed to read:
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
