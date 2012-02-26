Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2BZRke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 12:40:34 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52883 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838Ab2BZRkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 12:40:33 -0500
X-Sasl-enc: JnGMML6146jh6tnTfuIAs+e1gTLlYqcphtY3M4CkEKc2 1330278032
Date: Sun, 26 Feb 2012 09:40:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jidong Xiao <jidong.xiao@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120226174022.GB3531@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <CAG4AFWaDxK2r9W7eehAnWHxD92C_fjpL1OQnENuZFjOjXDOYmA@mail.gmail.com>
 <20120224165448.GA8751@kroah.com>
 <CAG4AFWb3y0GuKnun5Oiw7UEruUSaw78PoSxeyaXAN13o-aDrtw@mail.gmail.com>
 <20120225205540.GA29303@kroah.com>
 <CAG4AFWZOJ6_WtU50pZb6zzyBb7CWwphFzt_duyx_WTY45Gt1pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG4AFWZOJ6_WtU50pZb6zzyBb7CWwphFzt_duyx_WTY45Gt1pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 06:43:58PM -0500, Jidong Xiao wrote:
> On Sat, Feb 25, 2012 at 3:55 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Sat, Feb 25, 2012 at 02:23:07PM -0500, Jidong Xiao wrote:
> >> Hi, Greg,
> >>
> >> These two studies support my point. If the first one is too old, then
> >> the second one should be more convincing. To save your time, you can
> >> take a look at their conclusion first.
> >>
> >> An Empirical Study of Operating Systems Errors
> >> http://www.stanford.edu/~engler/metrics-sosp-01.pdf
> >>
> >> Faults in Linux: Ten Years Later
> >> http://pagesperso-systeme.lip6.fr/Suman.Saha/src/asplos11.pdf
> >
> > This second paper proves my point, it's funny that you tried to use it
> > to prove yours, you obviously must not have read the conclusion...
> >
> > Anyway, any paper that goes "look at all of these problems in the code!"
> > and isn't instantly followed by patches fixing ALL of those problems by
> > the authors of the paper, should be ignored as a troll masquerading as a
> > "study".
> >
> My point was "a significant portion of kernel crash incidents are due
> to bugs in drivers". You said no. I did *not* say bugs in device
> drivers are the dominant factor of kernel crashes/faults. So at least
> my point matches with the conclusion of the second paper. You can
> certainly say these academic studies are meaningless because they are
> not telling the whole story, but you can not deny the fact that
> because of the large code base, it is the almost impossible to
> eliminate all the bugs/problems from device drivers. That's why people
> are doing research to mitigate this problem, even though moving device
> drivers to user space may not be a good idea, or it is unrealistic in
> Linux, those researchers as well as their results deserve more
> respect. Everyone in the whole community, including kernel developers
> and researchers, shares the same goal, namely, improving the kernel
> code quality.

I don't see much help from the majority of researchers toward actually
helping change Linux for the better, their goals usually are just
publishing a paper and then moving on.

Yes, some stick around, and some people are working on making the
intersection between researchers and real-life more condusive toward
helping us out, but that is a hard task given that the goals of the two
groups are usually totally different in the end.

I suggest, if you have the time, to try to work with the researchers to
resolve the problems that they find.  They said that they found hundreds
of problems.  Why aren't those problems all now fixed?  What kept them
from getting fixed after they found them?  Was it something that the
community ignored, or did they not even try?  Find out the root cause of
that, and then, for their next paper, they might have something totally
different to report...

good luck,

greg k-h
