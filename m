Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0JNTC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:02:27 -0400
Received: from kroah.org ([198.145.64.141]:51165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab0JNTC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:02:26 -0400
Date: Thu, 14 Oct 2010 12:01:33 -0700
From: Greg KH <greg@kroah.com>
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] Add sc16is7x2 driver
Message-ID: <20101014190133.GB1009@kroah.com>
References: <4CAD818B.2070603@iis.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAD818B.2070603@iis.fraunhofer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 10:15:07AM +0200, Manuel Stahl wrote:
> --- /dev/null
> +++ b/include/linux/spi/sc16is7x2.h
> @@ -0,0 +1,17 @@
> +#ifndef LINUX_SPI_SC16IS752_H
> +#define LINUX_SPI_SC16IS752_H
> +
> +#define SC16IS7X2_NR_GPIOS 8
> +
> +struct sc16is7x2_platform_data {
> +	unsigned int	uartclk;
> +	/* uart line number of the first channel */
> +	unsigned	uart_base;
> +	/* number assigned to the first GPIO */
> +	unsigned	gpio_base;
> +	char		*label;
> +	/* list of GPIO names (array length = SC16IS7X2_NR_GPIOS) */
> +	const char	*const *names;
> +};
> +
> +#endif

Why is this needed in a .h file?  What other .c file uses this define
and structure?

thanks,

greg k-h
