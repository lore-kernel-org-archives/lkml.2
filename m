Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab1EGPmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 11:42:12 -0400
Received: from kroah.org ([198.145.64.141]:40790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab1EGPmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 11:42:09 -0400
Date: Sat, 7 May 2011 08:40:40 -0700
From: Greg KH <greg@kroah.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: -longterm kernels
Message-ID: <20110507154040.GC23672@kroah.com>
References: <201105030110.p431A5W0005426@hera.kernel.org>
 <20110504223605.GA5967@kroah.com>
 <20110505145854.GA4670@redhat.com>
 <20110505152501.GA14146@kroah.com>
 <20110507145503.GA2276@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110507145503.GA2276@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 07, 2011 at 04:55:03PM +0200, Stanislaw Gruszka wrote:
> On Thu, May 05, 2011 at 08:25:01AM -0700, Greg KH wrote:
> > > BTW, Greg, perhaps -logterm releasing policy should be revised somehow.
> > > Currently we have .32, .33, .34, .35 -longterm, what is kind a much.
> > 
> > It's not "much" if you rely on that kernel version, right?
> 
> Yes, but maybe would be better if they do not relay on some versions in
> long term manner, and i.e. .33 users would use .32 and .34 users would
> use .35 instead?

You would think, but those kernels are being maintained for a reason
that those people feel matter.

> So perhaps having well defined kernel.org rule/policy about which kernel
> version will be longterm updated, will allow distributions/users choose
> the same kernel version for they long live project. What in consequence
> will result that they together will have better tested and supported
> kernel.

Perhaps, but we've been doing just fine so far for over 5 years, right?
:)

> > Nor if you aren't doing the work, no one forces anyone to backport any
> > patches to older kernels if they don't want to.  The above patch was
> > asked to be backported as the original submitter wanted it there, hence
> > my asking for them to do it if they really wanted it.
> 
> Sure. Actually I didn't want to complain about that. When I wrote
> "less work", I rather meant "less work" for these who want to fix old
> kernels bugs for whatever reason.
> 
> > > If
> > > I could suggest something, would be nice to have longterm chosen
> > > versions predictable and constants i.e. one from every 3 kernel
> > > releases, like .35, .38, .41 ... . That would make distributions, that
> > > try to do release every half year very happy, because they will know
> > > what kernel to choose, which will be widely supported and tested.
> > 
> > The distros are the ones doing this -stable and -longterm work, so they
> > very well know exactly what is going on.
> 
> Hmm, I consider -stable rather as kernel.org project. People from
> different distributions/communities cc patches to -stable, review them,
> do backports ...
> 
> >  If they want to have a
> > specific kernel version marked as "-longterm", then they do the work to
> > do so.
> > 
> > What happens in the future, with future releases, is always unknown, as
> > hey, it's the future :)
> > 
> > So I really fail to understand what you are asking for here.
> 
> We have -stable rule that released kernel will be be updated until next
> release - about 2 months.

It's an informal rule, yes.

> I would like to add rule about -longterm kernels. That it have to be one
> form every 3 release, it will be updated about half a year - until next
> -longterm (with possibility of longer updates). Or some similar rule.

Nope, I'm not making such a rule, as you are trying to tell others what
to do here.  And I'm not going to do that.

Also, I'm not going to promise to do such maintainership either, and
last I checked, no distro is going to do that either.

> That version should be good choice for distros and any other long live
> project, and natural candidate for "real longterm" i.e. a few years
> updated/supported kernel version.

Again, distros know exactly what is going on here, they don't need
anything new.

sorry,

greg k-h
