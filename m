Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab1E0DWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 23:22:47 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:54389 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1E0DWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 23:22:46 -0400
Date: Thu, 26 May 2011 21:22:43 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Samsung: Move Samsung SoCs GPIO drivers to
 drivers/gpio
Message-ID: <20110527032243.GJ5032@ponder.secretlab.ca>
References: <20110520054441.GA9952@july>
 <20110520063128.GA21285@ponder.secretlab.ca>
 <20110521112102.GA11887@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521112102.GA11887@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 12:21:02PM +0100, Mark Brown wrote:
> On Fri, May 20, 2011 at 12:31:28AM -0600, Grant Likely wrote:
> > On Fri, May 20, 2011 at 02:44:41PM +0900, Kyungmin Park wrote:
> > >  .../gpiolib.c => drivers/gpio/s5pc100-gpio.c       |    0
> > >  .../gpiolib.c => drivers/gpio/s5pv210-gpio.c       |    0
> > >  .../gpiolib.c => drivers/gpio/samsung-gpiolib.c    |    3 +-
> 
> > drivers/gpio/gpio-*.c please.  I'm starting to enforce some level of
> > naming convention.
> 
> Hrm, looking at the current mainline drivers the existing tendency seems
> to be mostly towards gpio/*-gpio.c...

However, drivers/i2c/busses is nicely organized with i2c-*.c, and a
lot of the spi drivers are drivers/spi/spi* (although it is a mixed
bag here).  I also personally prefer the drivers to have the type as
a prefix instead of a suffix, and I hope to reorganize both
drivers/spi and drivers/gpio to follow the i2c lead in the next
cycle.

True, this does come down to personal taste, but unless someone has a
really strong objection to it then I'll keep asking for new drivers to
use gpio- as a prefix.

g.

