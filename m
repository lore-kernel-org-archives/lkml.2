Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab2EJPQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:16:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37880 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449Ab2EJPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:16:40 -0400
X-Sasl-enc: pi/+Kkh1uZ+dg3d3bxO9t8C7W+ZcJg2nFqfOSVHCZelf 1336663000
Date: Thu, 10 May 2012 08:16:39 -0700
From: Greg KH <greg@kroah.com>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120510151639.GE17472@kroah.com>
References: <20120503180056.GB13988@ioremap.net>
 <4FAAD584.70102@hrz.tu-chemnitz.de>
 <20120509220636.GA27659@kroah.com>
 <4FAAECB7.8070904@hrz.tu-chemnitz.de>
 <20120509222411.GA24302@kroah.com>
 <4FAAF1C4.2050500@hrz.tu-chemnitz.de>
 <20120509235723.GA7404@ioremap.net>
 <20120510000126.GA2357@kroah.com>
 <20120510004350.GA8362@ioremap.net>
 <4FAB4A4D.8080901@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAB4A4D.8080901@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 06:55:41AM +0200, Markus Franke wrote:
> Dear Evgeniy,
> 
> Am 10.05.2012 02:43, schrieb Evgeniy Polyakov:
> 
> > be used? Also, Markus, does DS28E04 change written/read data when doing
> > IO?
> 
> 
> Apart from masking the upper 6 bits within w1_f1C_write_pio() the data
> is directly being passed down to the DS28E04. So actually there is no
> other processing done within the driver. Furthermore, I added a new
> Documentation file to Documentation/w1/slaves directory which describes
> the interface of this driver.
> 
> @Greg: Is the "pio" binary file now legitimate or do I have to change it
> to a regular sysfs attribute?

I don't remember anything anymore, you will have to send the patch for
me to be able to properly review it and determine this.

greg k-h
