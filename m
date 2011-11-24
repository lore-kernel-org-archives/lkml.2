Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1KXAOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:14:03 -0500
Received: from trinity.fluff.org ([89.16.178.74]:58257 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab1KXAOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:14:00 -0500
Date: Thu, 24 Nov 2011 00:13:42 +0000
From: Ben Dooks <ben-i2c@fluff.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 3/5] SPI: Add helper macro for spi_driver boilerplate
Message-ID: <20111124001342.GN19115@trinity.fluff.org>
References: <1321434819-23678-1-git-send-email-lars@metafoo.de> <1321434819-23678-4-git-send-email-lars@metafoo.de> <CACxGe6tz0ppZj=a_e4rkgNxzhQ4MSCtXKXGk_dPov80QDU4MCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6tz0ppZj=a_e4rkgNxzhQ4MSCtXKXGk_dPov80QDU4MCg@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 10:12:54AM -0700, Grant Likely wrote:
> On Wed, Nov 16, 2011 at 2:13 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> > This patch introduces the module_spi_driver macro which is a convenience macro
> > for SPI driver modules similar to module_platform_driver. It is intended to be
> > used by drivers which init/exit section does nothing but register/unregister
> > the SPI driver. By using this macro it is possible to eliminate a few lines of
> > boilerplate code per SPI driver.
> >
> > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

I'm begining to think we need to make some of these driver and device
bits more generic... there seems to be so much similar but not quite
the same code.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

