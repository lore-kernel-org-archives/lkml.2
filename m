Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab2FFUWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:22:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34377 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756293Ab2FFUWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:22:33 -0400
Date: Wed, 6 Jun 2012 16:22:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: linux-kernel@vger.kernel.org, <gregkh@linuxfoundation.org>,
        <oneukum@suse.de>, <alan@lxorguk.ukuu.org.uk>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] fix usb skeleton driver
In-Reply-To: <1339013986.3437.20.camel@wall-e>
Message-ID: <Pine.LNX.4.44L0.1206061621110.1183-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Stefani Seibold wrote:

> The reason to fix the skeleton driver was about the complains for my
> NRPZ driver, which was based on the design of the usb skeleton driver.
> 
> > Going even farther, I'm not so sure it's a good idea for usb-skeleton
> > to try supporting both synchronous and asynchronous accesses.  This
> > adds a layer of complexity that people just don't need.  IMO it would 
> > be better to have two separate example drivers, an easy one that is 
> > purely synchronous and a more advanced one that is purely async.
> > 
> 
> Agree, i think this would be a good idea to have to separate drivers.
> Both should be also working drivers, for really simple hardware.
> 
> The best way for me to do this is to shrink later this to a simplified
> driver. 

That makes sense.  Will you do it?

> I think it is important to have a clean and working example. It would
> save a lot of time for everybody and shrinks the number of round trips.

How can you tell that it works?  By testing your NRPZ driver?

Alan Stern

