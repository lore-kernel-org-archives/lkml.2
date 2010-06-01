Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab0FAUzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:55:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757417Ab0FAUzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:55:36 -0400
Date: Tue, 1 Jun 2010 13:54:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Hemanth V <hemanthv@ti.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH V2] misc : ROHM BH1780GLI Ambient light sensor Driver
Message-Id: <20100601135430.9c8c28df.akpm@linux-foundation.org>
In-Reply-To: <4C056FEE.3040107@jic23.retrosnub.co.uk>
References: <39216.10.24.255.17.1274699065.squirrel@dbdmail.itg.ti.com>
	<20100601131244.7164b43c.akpm@linux-foundation.org>
	<4C056FEE.3040107@jic23.retrosnub.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jun 2010 21:39:10 +0100
Jonathan Cameron <kernel@jic23.retrosnub.co.uk> wrote:

> > 
> > It would be most useful if the changelog were to fully describe the
> > proposed kernel<->userspace interface.  That's the most important part
> > of the driver, because it's the only part we can never change.
> > 
> > There is a desultory effort to maintain sysfs API descriptions under
> > Documentation/ABI/.  I'd have thought that it would be appropriate to
> > document this driver's ABI in there.
> Agreed, but we get back to the debate of what we should standardise on.

I'd suggest standardising on one of the existing drivers.  That way we
have two compliant drivers and only need to change (n-2) others.  If we
pick some new standard then we need to change (n) drivers.

And we can't change the drivers, really.  They'd all end up needing to
provide two interfaces: one for the shiny-new-standard and one legacy.

> The main point of ALS before it died was exactly putting this standardization
> in place (admittedly the interface was slightly different from what we
> are proposing in IIO, but that was before Greg pointed out that sharing
> with hwmon would be a good idea!)
> 
> I have to admit I'm a little loath to spend too much time on this given
> the amount of time wasted previously (ALS).

Well, it's not a waste.  This is very important!  We appear to be
making a big mess which we can never fix up.

