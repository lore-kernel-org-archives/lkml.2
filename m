Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0IKATn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:19:43 -0400
Received: from kroah.org ([198.145.64.141]:43564 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab0IKATm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:19:42 -0400
Date: Fri, 10 Sep 2010 17:20:20 -0700
From: Greg KH <greg@kroah.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 2/2] posix clocks: introduce a sysfs presence.
Message-ID: <20100911002020.GA20252@kroah.com>
References: <cover.1283504065.git.richard.cochran@omicron.at> <84124d2479b8967cac2b35f852fc0fcae6ad9444.1283504065.git.richard.cochran@omicron.at> <20100910000008.1483fdd7@lxorguk.ukuu.org.uk> <20100910093135.GB10179@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910093135.GB10179@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 11:31:35AM +0200, Richard Cochran wrote:
> On Fri, Sep 10, 2010 at 12:00:08AM +0100, Alan Cox wrote:
> > Also we have existing time sources that don't follow the poxix clock
> > model - I can open /dev/rtc and I can open the hpet and so on.
> > 
> > I like /sys/class/time* *but* you need to be able to open the sysfs
> > device and apply operations to it in order for it to work when your closk
> > can be dynamically created and destroyed and to get a sane Unix API.
> > 
> > To start with try applying permissions to clock sources via the POSIX
> > API. That is something that will be required for some applications.
> > 
> > I need to be able to open sys/clock/foo/something and get a meaningful
> > handle. Sure it's quite likely the operations it supports are related to
> > the POSIX timer ops.
> 
> Do you mean this:
> 
>    id = read(/sys/clock/foo/lock); /* clock is busy, cannot be removed */

That's not for sysfs, if you want to do something like this, create
clockfs please :)

thanks,

greg k-h
