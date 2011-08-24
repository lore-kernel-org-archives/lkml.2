Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab1HXX6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:58:15 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42432 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab1HXX6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:58:14 -0400
X-Sasl-enc: Rp/FoB2vL3YhH/LdKcE1BogncwD0BysZVBJ2FRfYKQ2U 1314230293
Date: Wed, 24 Aug 2011 16:57:44 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick them).
Message-ID: <20110824235744.GA2187@kroah.com>
References: <20110815041524.GA7578@kroah.com>
 <alpine.DEB.2.02.1108150007100.24266@asgard.lang.hm>
 <20110815142142.GC11358@kroah.com>
 <25B374CC0D9DFB4698BB331F82CD0CF2E3ED78@wdscexbe08.sc.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25B374CC0D9DFB4698BB331F82CD0CF2E3ED78@wdscexbe08.sc.wdc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 10:26:54PM -0700, Daniel Taylor wrote:
> For embedded systems, which often have multi- (not just two-) year
> warranties, it sounds like we would then be maintaining the -longterm
> ourselves.  The "easy" side of this is that embedded systems don't
> (usually) have users trying to plug in the latest and greatest widget,
> except on external busses, such as USB.  So back-porting drivers is
> not generally a big deal.  Security patches, OTOH, are a real concern.
> Other than net and drivers/net, which are exposed to non-local attacks,
> are there other subsystems we should watch for security fixes?  There
> have, for example, been a lot of security upgrades in /sys, but there's
> also been a lot of restructing for new interfaces and "arch" models,
> which would make back-porting those much more complicated.

You should watch out for all bugfixes, that's the only way to have a
chance at catching all of the issues.

good luck,

greg k-h
