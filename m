Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064Ab2EDAYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 20:24:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45736 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab2EDAYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 20:24:34 -0400
MIME-Version: 1.0
In-Reply-To: <m2mx60m99c.fsf@firstfloor.org>
References: <4F96A881.7050507@gmail.com> <m2mx60m99c.fsf@firstfloor.org>
From: Hui Zhu <teawater@gmail.com>
Date: Fri, 4 May 2012 08:23:53 +0800
Message-ID: <CANFwon3pEkt7Mz1CedGQOw2UpqxUfsSN5Xfiz5FU+FSAbnFpug@mail.gmail.com>
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20120424 release(doc update)[1/3]code
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 17:49, Andi Kleen <andi@firstfloor.org> wrote:
> Hui Zhu <teawater@gmail.com> writes:

Hi Andi,

Thanks for your mail.

>
> Could you please split it down further. a 9kLOC patch is pretty daunting.
>
> From a quick glance over some focus on simplication would be good: no
> own allocators (kernel has enough), no own types (that would remove
> asm), remove optional facilities like the private ring buffer. Some
> obsolete code like using semaphores vs mutexes. The variable list looks
> overcomplicated, just use an array? Generally too many macros I would
> say, try using inlines or removing them.
>
> Do you have any rarely used optional features that could be left out a
> version 1? If yes do that.  I'm sure with some effort the 9kLOC could be
> much less. A patch half the size would be much easier to merge.
>

Your comments is very helpful for me.  I spent more time on add more
function to KGTP, make it more faster and make module support more
older kernel in before.  But the review patch is not very clear.  I
will post a new patch for review that just keep the base function of
KGTP to make it more easy to review.  Please keep help me with it.

> There are some things that checkpatch will likely warn about.
>
> It would be good if you could describe the use case a bit better:
> this is for the kernel only or also user applications?

Most of function is for the Linux kernel.  You can get them from the
doc in http://code.google.com/p/kgtp/wiki/HOWTO
And I am trying to make KGTP can do some thing for user application
too.  http://code.google.com/p/kgtp/wiki/hotcode this is an example to
use KGTP analyze user application performance bottleneck.
I am just adding the function that can access to the memory of an user
application memory directly without interrupt it.  And another plan is
use KGTP get backtrace of user application without interrupt it.

Thanks,
Hui

>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
