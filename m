Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148Ab0KPOaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:30:46 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37470 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758316Ab0KPOak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:30:40 -0500
Date: Tue, 16 Nov 2010 15:30:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Greg KH <gregkh@suse.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-serial@vger.kernel.org,
        Grant Edwards <grant.b.edwards@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation about RS485 serial communications
Message-ID: <20101116143016.GB6527@ucw.cz>
References: <20100408111310.524f7354@lxorguk.ukuu.org.uk>
 <4CBD8EE4.5040808@evidence.eu.com>
 <i9ka0s$4ua$1@dough.gmane.org>
 <201010191727.53314.alexander.stein@systec-electronic.com>
 <i9kk4o$svc$1@dough.gmane.org>
 <4CC418A9.6090602@evidence.eu.com>
 <4CDA630F.4060903@atmel.com>
 <20101110172842.GC12371@suse.de>
 <4CDBC3EC.6020707@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDBC3EC.6020707@evidence.eu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Documentation about RS485 serial communications

I have seen hardware (kontron pmc-6l) that was capable of switching
between RS232, RS485 and one other standard by software.

Is such hw common? If so, should we have standard interface?

> +   From user-level, RS485 configuration can be get/set using the previous
> +   ioctls. For instance, to set RS485 you can use the following code:
> +
> +	#include <linux/serial.h>
> +
> +	/* Driver-specific ioctls: */
> +	#define TIOCGRS485      0x542E
> +	#define TIOCSRS485      0x542F
> +
> +	/* Open your specific device (e.g., /dev/mydevice): */
> +	int fd = open ("/dev/mydevice", O_RDWR);
> +	if (fd < 0) {
> +		/* Error handling. See errno. */
> +	}
> +
> +	struct serial_rs485 rs485conf;
> +
> +	/* Set RS485 mode: */
> +	rs485conf.flags |= SER_RS485_ENABLED;

IOW... is this supposed to switch electrical levels?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
