Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2GKAPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:15:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36681 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412Ab2GKAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:15:46 -0400
X-Sasl-enc: zpuNEQfbYjK8ie8qj/vEBLnHk98Y0YFnurP2EXiBrXVi 1341965745
Date: Tue, 10 Jul 2012 17:15:44 -0700
From: Greg Kroah-Hartmann <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Joe Perches <joe@perches.com>,
        Kay Sievers <kay@vrfy.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
Message-ID: <20120711001544.GA17631@kroah.com>
References: <20120709180328.GA4105@redhat.com>
 <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
 <1341859731.801.0.camel@mop>
 <1341865916.6118.25.camel@joe2Laptop>
 <20120709204019.GA10111@kroah.com>
 <1341866664.6118.30.camel@joe2Laptop>
 <20120709205631.GA22980@kroah.com>
 <20120711001145.GB10518@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120711001145.GB10518@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 08:11:45PM -0400, Dave Jones wrote:
> On Mon, Jul 09, 2012 at 01:56:31PM -0700, Greg Kroah-Hartman wrote:
>  > > > > That single patch doesn't apply cleanly to Linus'
>  > > > > 8c84bf4166a4698296342841a549bbee03860ac0
>  > > > > 
>  > > > > What else is necessary?
>  > > > > 
>  > > > > Your tree seems to have a collection of random patches.
>  > > > > 
>  > > > > It might be useful to clone Linus' tree and produce a
>  > > > > branch with all the necessary printk patches in it so
>  > > > > someone else could pull it.
>  > > > 
>  > > > They should all now be in my driver-core-next branch that will show up
>  > > > in the next linux-next release, so having a separate tree isn't
>  > > > necessary.
>  > > 
>  > > I don't think so.
>  > > 
>  > > There are real defects in the existing code.
>  > > 
>  > > These are patches that are necessary _now_.
>  > > not for a -next 3.6 future.
>  > 
>  > Oops, sorry, I ment to type, "driver-core-linus" above.
> 
> Can you get this to Linus asap please ? I just had an oops that scrolled
> off the screen because the Code: line suffers the same problem.
> Thankfully serial console caught most of it, but I had to hand-edit
> a lot of crap just to make it readable again.

It will be sent tomorrow, I wanted to get it tested in linux-next at
least for one day.

thanks,

greg k-h
