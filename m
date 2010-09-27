Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0I0V0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:26:54 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42147 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0I0V0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:26:54 -0400
X-Originating-Ip: 216.16.235.2
Date: Mon, 27 Sep 2010 17:26:50 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext3 filesystem corruption in user mode linux
Message-ID: <20100927212650.GA20386@foursquare.net>
References: <20100924041410.GA18040@foursquare.net> <20100924060557.GA21238@foursquare.net> <20100924064446.GA22588@foursquare.net> <AANLkTinQ20uSgFP5KV17B0J0v8Y0zAg=AgAd_kf+4Bh0@mail.gmail.com> <20100927211842.GA19667@foursquare.net> <AANLkTinYjJ8m6UjsR++zFCxo4jecDEzCAX_F_CF6NwZV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinYjJ8m6UjsR++zFCxo4jecDEzCAX_F_CF6NwZV@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 11:25:11PM +0200, richard -rw- weinberger wrote:
> On Mon, Sep 27, 2010 at 11:18 PM, Chris Frey <cdfrey@foursquare.net> wrote:
> > On Mon, Sep 27, 2010 at 11:04:07PM +0200, richard -rw- weinberger wrote:
> >> On Fri, Sep 24, 2010 at 8:44 AM, Chris Frey <cdfrey@foursquare.net> wrote:
> >> > On Fri, Sep 24, 2010 at 02:05:57AM -0400, Chris Frey wrote:
> >> >> So far I have been unable to make 2.6.32.21 corrupt its filesystem
> >> >> when running as the UML kernel (Host 2.6.35.4, UML 2.6.32.21)
> >> >
> >> > Spoke too soon... 2.6.32.21 has errors too, if pushed hard enough.
> >> >
> >>
> >> can you do a git bisect?
> >
> > I've been trying, but so far the range of buggy versions stretches back
> > to 2.6.32.x at least. ?I'm trying to find a version that doesn't have
> > this issue.
> >
> > I'm kinda surprised that nobody else has run into this. ?Or maybe user
> > mode linux isn't used as much as I thought? ? Or I'm just doing something
> > completely bone headed. :-)
> 
> Hmm, maybe this issue affects only your configuration.
> When I have some spare time I'll try to trigger this on my setup.

That would be great.  Let me know if you need any specific data from my end.

- Chris

