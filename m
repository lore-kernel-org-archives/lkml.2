Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab0D1RXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:23:15 -0400
Received: from kroah.org ([198.145.64.141]:59737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab0D1RXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:23:14 -0400
Date: Wed, 28 Apr 2010 10:22:31 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Valdis.Kletnieks@vt.edu, Greg KH <gregkh@suse.de>,
       devel@driverdev.osuosl.org, Scott Smedley <ss@aao.gov.au>,
       Jason Baldus <jason.baldus@gmail.com>, linux-kernel@vger.kernel.org,
       Harley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 1/3] drivers/staging/dt3155: Integrate 3 badly styled
 files into 1 clean file
Message-ID: <20100428172231.GA14343@kroah.com>
References: <cover.1269847733.git.joe@perches.com>
 <ba7a1e2464417043f00f78f6ddaab260c23c3cc9.1269847733.git.joe@perches.com>
 <20100427230228.GB17260@kroah.com>
 <1272432603.23132.30.camel@Joe-Laptop.home>
 <20100428053427.GA14510@kroah.com>
 <1272433474.23132.34.camel@Joe-Laptop.home>
 <20100428055237.GA14978@suse.de>
 <1272434430.23132.35.camel@Joe-Laptop.home>
 <10533.1272471159@localhost>
 <1272472405.18228.16.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272472405.18228.16.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 09:33:25AM -0700, Joe Perches wrote:
> On Wed, 2010-04-28 at 12:12 -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 27 Apr 2010 23:00:30 PDT, Joe Perches said:
> > > On Tue, 2010-04-27 at 22:52 -0700, Greg KH wrote:
> > > > > I seem to be learning that you little taste.
> > > > -ENOPARSE
> > > 
> > > Choosing competing patches based on date received
> > > order not quality is poor taste.
> > 
> > So you're saying when Greg gets a somewhat ugly but passable patch 2 weeks ago,
> > he's supposed to *just know* that you'll be submitting a possibly better one 2
> > weeks later and wait for it to show up?
> 
> No, I'm saying that when Greg gets multiple
> patches for the same module and doesn't act on
> any of them for several weeks, (in this case
> one 6 weeks ago, and two others 4 weeks ago)
> he should select the better patches, not just
> apply the first one in chronological order.

In this case, I _did_ select the best patches.  Your "do it all in one
patch" was not acceptable, especially as others sent small,
do-one-thing, type patches.

I'm sorry you don't agree with this decision, but that was my call.

thanks,

greg k-h
