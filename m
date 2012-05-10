Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2EJDnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:43:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33073 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab2EJDnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:43:50 -0400
X-Sasl-enc: KtGM7rRffY8gIc68x8vfRF32tLrTaKi1k3qBHszU3Myx 1336621429
Date: Wed, 9 May 2012 20:43:48 -0700
From: Greg KH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120510034348.GB18484@kroah.com>
References: <20120502202134.GB26628@kroah.com>
 <20120503180056.GB13988@ioremap.net>
 <4FAAD584.70102@hrz.tu-chemnitz.de>
 <20120509220636.GA27659@kroah.com>
 <4FAAECB7.8070904@hrz.tu-chemnitz.de>
 <20120509222411.GA24302@kroah.com>
 <4FAAF1C4.2050500@hrz.tu-chemnitz.de>
 <20120509235723.GA7404@ioremap.net>
 <20120510000126.GA2357@kroah.com>
 <20120510004350.GA8362@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510004350.GA8362@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 04:43:50AM +0400, Evgeniy Polyakov wrote:
> On Wed, May 09, 2012 at 05:01:26PM -0700, Greg KH (greg@kroah.com) wrote:
> > Binary sysfs files should be "pass through" only, the kernel should not
> > touch the data involved in them at all, it is a pipe directly from the
> > kernel to userspace for binary blob data, like firmware images.  You
> > should never do any processing of any binary file data at all in the
> > kernel.
> 
> And if some of the data should be somehow changed, what interfact should
> be used? Also, Markus, does DS28E04 change written/read data when doing
> IO?
> 
> I must admit, I never heared that binary sysfs files have to follow this
> constraint.

For some reason I thought I had documented it years ago, but in digging
through the Documentation directory, I don't see it anywhere, sorry
about that.

I'll add it to my ever-growing TODO list...

thanks,

greg k-h
