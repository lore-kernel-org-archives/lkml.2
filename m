Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761250Ab2EIWYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:24:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34979 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753538Ab2EIWYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:24:13 -0400
X-Sasl-enc: nQztIbMfzZeE6lL3wljE3J5YnAZZ4oBuJIZC7esW2e67 1336602252
Date: Wed, 9 May 2012 15:24:11 -0700
From: Greg KH <greg@kroah.com>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120509222411.GA24302@kroah.com>
References: <20120430021300.GA18148@kroah.com>
 <4FA1953B.40008@hrz.tu-chemnitz.de>
 <20120502202134.GB26628@kroah.com>
 <20120503180056.GB13988@ioremap.net>
 <4FAAD584.70102@hrz.tu-chemnitz.de>
 <20120509220636.GA27659@kroah.com>
 <4FAAECB7.8070904@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAAECB7.8070904@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, May 10, 2012 at 12:16:23AM +0200, Markus Franke wrote:
> Dear Greg,
> 
> the file "pio" is used for reading the current PIO state of the
> DS28E04-100.

Why is this a binary file?  That seems like it should not be, as a
binary sysfs file should be "pass-through" only.

> The "eeprom" file is for reading/writing the EEPROM memory of the same
> device.

That seems ok.

> As already mentioned before this is exactly the way how other w1 slave
> drivers are handling stuff like this.

Then those drivers are wrong as well, sorry :(

thanks,

greg k-h
