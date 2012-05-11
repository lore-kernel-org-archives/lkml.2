Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab2EKNXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:23:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:32327 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759815Ab2EKNXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:23:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142772639"
Date: Fri, 11 May 2012 15:32:50 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mfd: add LM3533 lighting-power core driver
Message-ID: <20120511133250.GL1214@sortiz-mobl>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-2-git-send-email-jhovold@gmail.com>
 <20120509144218.GI1794@sortiz-mobl>
 <20120510120742.GA29437@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510120742.GA29437@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johan,

On Thu, May 10, 2012 at 02:07:42PM +0200, Johan Hovold wrote:
> On Wed, May 09, 2012 at 04:42:18PM +0200, Samuel Ortiz wrote:
> > Hi Johan
> > 
> > On Thu, May 03, 2012 at 12:26:36PM +0200, Johan Hovold wrote:
> > > Add support for National Semiconductor / TI LM3533 lighting power chips.
> > > 
> > > This is the core driver which provides register access over I2C and
> > > registers the ambient-light-sensor, LED and backlight sub-drivers.
> > > 
> > > Signed-off-by: Johan Hovold <jhovold@gmail.com>
> > > ---
> > > 
> > > v2:
> > >  - add sysfs-ABI documentation
> > >  - merge i2c implementation with core
> > >  - use regmap and kill custom debugfs interface
> > > 
> > > 
> > >  .../ABI/testing/sysfs-bus-i2c-devices-lm3533       |   38 +
> > >  drivers/mfd/Kconfig                                |   13 +
> > >  drivers/mfd/Makefile                               |    1 +
> > >  drivers/mfd/lm3533-core.c                          |  717 ++++++++++++++++++++
> > >  drivers/mfd/lm3533-ctrlbank.c                      |  134 ++++
> > >  include/linux/mfd/lm3533.h                         |   89 +++
> > >  6 files changed, 992 insertions(+), 0 deletions(-)
> > >  create mode 100644 Documentation/ABI/testing/sysfs-bus-i2c-devices-lm3533
> > >  create mode 100644 drivers/mfd/lm3533-core.c
> > >  create mode 100644 drivers/mfd/lm3533-ctrlbank.c
> > >  create mode 100644 include/linux/mfd/lm3533.h
> > Patch applied to my for-next branch, thanks.
> 
> I've been travelling for a few days and didn't have time to submit a
> discussed change to move two attributes to the platform data before I
> left.
> 
> Could you please apply the following two patches on top of this one?
All of your 4 pending patches have been applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
