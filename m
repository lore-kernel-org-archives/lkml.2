Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2GIVIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:08:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47672 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750860Ab2GIVIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:08:51 -0400
Message-ID: <1341868130.6118.34.camel@joe2Laptop>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 09 Jul 2012 14:08:50 -0700
In-Reply-To: <CAPXgP12AN61VxUGb0-=tyChnipUENzwLUNWEZtfFS2oCyYUqHQ@mail.gmail.com>
References: <20120709180328.GA4105@redhat.com>
	 <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
	 <1341859731.801.0.camel@mop> <1341865916.6118.25.camel@joe2Laptop>
	 <20120709204019.GA10111@kroah.com> <1341866664.6118.30.camel@joe2Laptop>
	 <CAPXgP12AN61VxUGb0-=tyChnipUENzwLUNWEZtfFS2oCyYUqHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 22:48 +0200, Kay Sievers wrote:
> On Mon, Jul 9, 2012 at 10:44 PM, Joe Perches <joe@perches.com> wrote:
> 
> >> > That single patch doesn't apply cleanly to Linus'
> >> > 8c84bf4166a4698296342841a549bbee03860ac0
> >> >
> >> > What else is necessary?
> >> >
> >> > Your tree seems to have a collection of random patches.
> >> >
> >> > It might be useful to clone Linus' tree and produce a
> >> > branch with all the necessary printk patches in it so
> >> > someone else could pull it.
> 
> I just worked on top of Greg's tree with the pending stuff for 3.5.

No worries Kay, as long as there's a tree with just printk
patches, it'll all work out.

> >> They should all now be in my driver-core-next branch that will show up
> >> in the next linux-next release, so having a separate tree isn't
> >> necessary.
> >
> > I don't think so.
> >
> > There are real defects in the existing code.
> >
> > These are patches that are necessary _now_.
> > not for a -next 3.6 future.
> 
> Wrong conclusion. They are not in the 3.6 branch, but still go into -next:
>   http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=shortlog;h=refs/heads/driver-core-linus

That's the drivers-core-linus branch not the -next one.
Greg said -next.  Anyway, it's not a problem, Greg just
mistyped.  I do that too.  Sometimes too often.

cheers, Joe


