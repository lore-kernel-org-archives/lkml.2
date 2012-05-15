Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966683Ab2EOUAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 16:00:46 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48195 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966182Ab2EOUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 16:00:30 -0400
Date: Tue, 15 May 2012 22:00:27 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johan Hovold <jhovold@gmail.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3] iio: add LM3533 ambient-light-sensor driver
Message-ID: <20120515200027.GA9132@localhost>
References: <1336040799-18433-3-git-send-email-jhovold@gmail.com>
 <1337100396-29024-1-git-send-email-jhovold@gmail.com>
 <20120515122705.42461e7e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515122705.42461e7e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 12:27:05PM -0700, Andrew Morton wrote:
> On Tue, 15 May 2012 18:46:36 +0200
> Johan Hovold <jhovold@gmail.com> wrote:
> 
> > Add sub-driver for the ambient-light-sensor interface on National
> > Semiconductor / TI LM3533 lighting power chips.
> > 
> > The sensor interface can be used to control the LEDs and backlights of
> > the chip through defining five light zones and three sets of
> > corresponding brightness target levels.
> > 
> > The driver provides raw and mean adc readings along with the current
> > light zone through sysfs. A threshold event can be generated on zone
> > changes.
> >
> > ...
> >
> >  drivers/staging/iio/light/Kconfig                  |   16 +
> >  drivers/staging/iio/light/Makefile                 |    1 +
> >  drivers/staging/iio/light/lm3533-als.c             |  726 ++++++++++++++++++++
> 
> Why is this aimed at drivers/staging/, rather than directly into
> drivers/iio/?

I understood it as it was only iio core which was moving out of staging
in 3.5, but I see now that some drivers have been added directly to
driver/iio. My mistake.

I'll make sure to move it to drivers/iio/light.

Thanks for pointing it out,
Johan
