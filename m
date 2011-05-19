Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1ESF3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:29:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43047 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab1ESF3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jOQn6npqoMTsH8jRA72kOyWGwL0PUGTYYExMYFJgKL8gFtbg0bgdYEB+WVl2B6UKgC
         9jQ0eP/Y9gJ3VJhnYw7Z/hV9egkg+UvycdgwXxrKuuISAK1qZEL3e49TiY00XhZ1FNtX
         NvEfiz5Dt1QltBzqRjOWSRmysn98BA5n7HoVM=
Date: Thu, 19 May 2011 07:29:03 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: New boot time message: detected capacity change
Message-ID: <20110519052903.GA2904@mtj.dyndns.org>
References: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com>
 <BANLkTimY+y3vXa0R7Evs6dYLVjJ==KVq1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimY+y3vXa0R7Evs6dYLVjJ==KVq1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Wed, May 18, 2011 at 01:50:19PM -0700, Linus Torvalds wrote:
> As it was, I feel that those commit descriptions were actively
> misleading me into thinking this was a regression.

The commit message is incomplete rather than misleading.  The problem
has been there for a long time but hasn't affected cdrom so not many
people have noticed it.  The changes to media revalidation exposed the
bug for cdrom too, so it became a regression for 2.6.38.  Please refer
to the following thread.

  https://lkml.org/lkml/2011/3/31/436

As the root cause was the same as the 2009 bug, I just referenced that
one.  I should have included the link to the newer thread or explained
how it affected recent conversion from ->media_changed to
->check_events.  My bad.

> Maybe it won't cause any problems, but -rc7 is not the time to make
> these kinds of experiments!

The patch was posted Apr 6th.  It somehow took quite long to reach
your tree.  Sorry about that too.

As for the warning message, I think it wouldn't be harmful but at -rc7
I'm a bit nervous too.  I'll take a deeper look.

Thank you.

--
tejun
