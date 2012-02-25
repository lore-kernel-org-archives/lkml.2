Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2BYU4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 15:56:23 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52369 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899Ab2BYU4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 15:56:22 -0500
X-Sasl-enc: cTgk8LvjvAB3ie5GA6+aJgxTxqZrM+/PNI3zgBEXrD6s 1330203381
Date: Sat, 25 Feb 2012 12:55:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jidong Xiao <jidong.xiao@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120225205540.GA29303@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <CAG4AFWaDxK2r9W7eehAnWHxD92C_fjpL1OQnENuZFjOjXDOYmA@mail.gmail.com>
 <20120224165448.GA8751@kroah.com>
 <CAG4AFWb3y0GuKnun5Oiw7UEruUSaw78PoSxeyaXAN13o-aDrtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG4AFWb3y0GuKnun5Oiw7UEruUSaw78PoSxeyaXAN13o-aDrtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 02:23:07PM -0500, Jidong Xiao wrote:
> Hi, Greg,
> 
> These two studies support my point. If the first one is too old, then
> the second one should be more convincing. To save your time, you can
> take a look at their conclusion first.
> 
> An Empirical Study of Operating Systems Errors
> http://www.stanford.edu/~engler/metrics-sosp-01.pdf
> 
> Faults in Linux: Ten Years Later
> http://pagesperso-systeme.lip6.fr/Suman.Saha/src/asplos11.pdf

This second paper proves my point, it's funny that you tried to use it
to prove yours, you obviously must not have read the conclusion...

Anyway, any paper that goes "look at all of these problems in the code!"
and isn't instantly followed by patches fixing ALL of those problems by
the authors of the paper, should be ignored as a troll masquerading as a
"study".

greg k-h
