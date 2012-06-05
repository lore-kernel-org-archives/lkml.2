Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab2FEGt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 02:49:56 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56185 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab2FEGty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 02:49:54 -0400
Date: Mon, 4 Jun 2012 21:11:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH v5] iio: add LM3533 ambient-light-sensor driver
Message-ID: <20120605041128.GA30374@kroah.com>
References: <1337346461-31220-1-git-send-email-jhovold@gmail.com>
 <1337602686-28007-1-git-send-email-jhovold@gmail.com>
 <4FBB5A13.4060301@kernel.org>
 <20120522094020.GC7323@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522094020.GC7323@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 11:40:20AM +0200, Johan Hovold wrote:
> On Tue, May 22, 2012 at 10:19:15AM +0100, Jonathan Cameron wrote:
> > On 5/21/2012 1:18 PM, Johan Hovold wrote:
> > > Add sub-driver for the ambient-light-sensor interface on National
> > > Semiconductor / TI LM3533 lighting power chips.
> > >
> > > The sensor interface can be used to control the LEDs and backlights of
> > > the chip through defining five light zones and three sets of
> > > corresponding output-current values.
> > >
> > > The driver provides raw and mean adc readings along with the current
> > > light zone through sysfs. A threshold event can be generated on zone
> > > changes. The ALS-control output values can be set per zone for the three
> > > current output channels.
> > There are a few bits of documentation I'd rather were in
> > sysfs-bus-iio but we can move them any time.
> > 
> > I haven't compile tested as no machine availability till this evening.
> > Please do one last sanity check against staging-next.
> 
> Tested against staging-next of today (c3c6cc91b0ae7b).
> 
> Greg, any chance you can pick this one up for 3.5?

To late for 3.5, the merge window for new stuff closed a week or so
before 3.4 came out, as stuff needs to be tested in linux-next.

I've queued it up now to be merge in 3.6.

thanks,

greg k-h
