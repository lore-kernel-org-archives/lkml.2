Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab1HXE53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:57:29 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:32855 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795Ab1HXE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:57:28 -0400
X-Sasl-enc: 9GVLxA9nNDVusbiX88hNlHcPcx/I7Y7umtNKb68MWWsF 1314161847
Date: Tue, 23 Aug 2011 21:57:02 -0700
From: Greg KH <greg@kroah.com>
To: Brian Swetland <swetland@google.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tim Bird <tbird20d@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stable-review@kernel.org, stable@kernel.org,
        tim.bird@am.sony.com,
        Arve =?iso-8859-1?Q?Hj=F8nnev=E5?= <arve@android.com>
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick them).
Message-ID: <20110824045702.GA1674@kroah.com>
References: <20110815041524.GA7578@kroah.com>
 <CA+bK7J7_EKdQACnoJGWkd4asH+096SJ-gjEvsnjmRX6Dmc6dpA@mail.gmail.com>
 <20110817045856.GB4936@kroah.com>
 <20110817132114.GB10209@sirena.org.uk>
 <CANqkERC2eyy3SQ6_vJncvuMdi=Yu=O8mZoXkggkX1q_4=d+q7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqkERC2eyy3SQ6_vJncvuMdi=Yu=O8mZoXkggkX1q_4=d+q7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 10:33:05AM -0700, Brian Swetland wrote:
> As far as long-term kernels goes, from the Android perspective we
> strongly prefer to snap up to the most recent released kernel on every
> platform/device release.  I prefer to be as up to date on bugfixes and
> features from mainline as possible and minimize the deltas on our
> stack 'o patches as much as possible.

That's good to hear.

> We've been getting more aggressive about merging in the -rc#s and then
> rebasing on the final during development (before final stabilization
> freeze for a release) in the last year or so, and it seems to work
> pretty well.

Is your kernel git tree public during this merge cycle so that others
can track it?  I tried to dig through android.kernel.org but there are a
lot of different kernel trees there :(

> Not all OEMs or silicon vendors are as comfortable with this approach
> and I expect some would welcome a long term tree they can count on to
> get critical fixes for, though.  Device release teams (even our own,
> for lead devices we work on) are notoriously risk-averse (often for
> good reasons), and tend to get really nervous when they see the total
> change count or diff stat for pulling up to a new kernel release close
> to "final rom" for a product.

That's understandable.

So that kind of means they would like such a longterm tree, but they
have the problem that your patches move forward to a newer kernel, but
are not maintained for that longterm kernel.  Are they responsible for
maintaining this themselves then, or do you help with providing your
patchset on top of all of the different kernel versions that the OEMs
and others need?

thanks,

greg k-h
