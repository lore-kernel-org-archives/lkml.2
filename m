Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2BBCdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:33:12 -0500
Received: from imr3.ericy.com ([198.24.6.13]:38179 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab2BBCdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:33:10 -0500
Date: Wed, 1 Feb 2012 18:31:29 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
Message-ID: <20120202023129.GA19535@ericsson.com>
References: <20110419145303.111aead7@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110419145303.111aead7@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 08:53:03AM -0400, Jean Delvare wrote:
> I need this to handle SMBus multiplexing on my Asus Z8NA-D6 board. It
> has an ICH10, I've added support for older ICH chips in case someone
> needs it, as it was relatively simply to do that.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
> Note 1: On early ICH chips, some pins are exclusively inputs or
> outputs. The driver doesn't currently enforce this.
> 
> Note 2: I'm not yet sure if we want a module alias for this driver.
> Many systems have the device but only a few of them will need the
> driver (and an ACPI resource conflict will be reported for many
> others, especially laptops I suspect.) So it might make more sense to
> let consumer drivers request the i801_gpio driver as needed (which they
> should do anyway, as you can't assume udev is always up and running on
> all systems.)
> 
> Note 3: This is my first GPIO driver, so while it works fine for me, it
> might not be perfect. I welcome comments on how to improve it.
> 
>  drivers/gpio/Kconfig     |    7
>  drivers/gpio/Makefile    |    1
>  drivers/gpio/i801_gpio.c |  432 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 440 insertions(+)
> 
Did this or an alternate patch for gpio support on the recent Intel ICHs go anywhere ?

I found another patch which is using a different approach, but I don't see anything
in the latest kernel.

Thanks,
Guenter
