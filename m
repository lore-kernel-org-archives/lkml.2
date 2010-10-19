Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0JSP57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:57:59 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:42132 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab0JSPzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:55:45 -0400
X-Greylist: delayed 1668 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2010 11:55:45 EDT
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Documentation about RS485 serial communications
Date: Tue, 19 Oct 2010 17:27:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-gentoo-r11; KDE/4.4.5; x86_64; ; )
Cc: Grant Edwards <grant.b.edwards@gmail.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <20100408111310.524f7354@lxorguk.ukuu.org.uk> <4CBD8EE4.5040808@evidence.eu.com> <i9ka0s$4ua$1@dough.gmane.org>
In-Reply-To: <i9ka0s$4ua$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010191727.53314.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 October 2010, 16:29:48 Grant Edwards wrote:
> On 2010-10-19, Claudio Scordino <claudio@evidence.eu.com> wrote:
> > +2. HARDWARE-RELATED CONSIDERATIONS
> > +
> > +   Some CPUs (e.g., Atmel AT91) contain a transceiver capable of working
> > both +   as RS232 and RS485.
> 
> Pardon my curiosity, but I've looked at a few AT91 parts, and I've
> never seen on with an internal transceiver -- nor does Google seem
> able to find any.
> 
> Frankly, I'd be pretty surprised, since it would be very difficult
> (fab-wise), to build a mircoprocessor with I/O cells capable of
> withstanding the voltage levels specified in RS232.
> 
> Can you specify to which parts you're referring?

I doubt the AT91 do have an internal transceiver but it has a dedicated pin 
feature (RTS or CTS or something) which can be used to switch between RS232 
and RS485 by setting a bit in the USART provided the pin is connected 
properly.

Regards,
Alexander
