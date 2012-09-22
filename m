Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2IVS4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 14:56:11 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59553 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2IVS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 14:56:09 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 22 Sep 2012 11:56:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH resend] spi core: Provide means to instantiate devices
 through sysfs
Message-ID: <20120922185625.GA19323@roeck-us.net>
References: <1347925880-13076-1-git-send-email-linux@roeck-us.net>
 <20120922161133.GU4495@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120922161133.GU4495@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 12:11:33PM -0400, Mark Brown wrote:
> On Mon, Sep 17, 2012 at 04:51:20PM -0700, Guenter Roeck wrote:
> > The I2C core provides a means to instantiate devices from userspace
> > using sysfs attributes. Provide the same mechanism for SPI devices.
> 
> So, unlike I2C this is only going to work for a subset of controllers -
> anything that relies on GPIOs for chip select will need more data to add
> the chip selects for example.  This means I'm having a hard time getting
> enthused about the idea, it seems like it might be a support burden.
> 
Yes, obviously that model can not be used if SPI chip select is handled outside
the SPI master driver.

Anyway, no problem. That the code is useful for me doesn't mean it has to be
useful for others. I'll make it available as branch on my linux tree on github.

Thanks,
Guenter
