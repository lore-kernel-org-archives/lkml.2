Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab2FGINO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:13:14 -0400
Received: from www84.your-server.de ([213.133.104.84]:38581 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2FGINF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:13:05 -0400
Message-ID: <1339056804.4964.8.camel@wall-e>
Subject: Re: [PATCH] fix usb skeleton driver
From: Stefani Seibold <stefani@seibold.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Date: Thu, 07 Jun 2012 10:13:24 +0200
In-Reply-To: <Pine.LNX.4.44L0.1206061621110.1183-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1206061621110.1183-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 06.06.2012, 16:22 -0400 schrieb Alan Stern:
> On Wed, 6 Jun 2012, Stefani Seibold wrote:
> 
> > The reason to fix the skeleton driver was about the complains for my
> > NRPZ driver, which was based on the design of the usb skeleton driver.
> > 
> > > Going even farther, I'm not so sure it's a good idea for usb-skeleton
> > > to try supporting both synchronous and asynchronous accesses.  This
> > > adds a layer of complexity that people just don't need.  IMO it would 
> > > be better to have two separate example drivers, an easy one that is 
> > > purely synchronous and a more advanced one that is purely async.
> > > 
> > 
> > Agree, i think this would be a good idea to have to separate drivers.
> > Both should be also working drivers, for really simple hardware.
> > 
> > The best way for me to do this is to shrink later this to a simplified
> > driver. 
> 
> That makes sense.  Will you do it?

Yes, if nobody other will do this.

> 
> > I think it is important to have a clean and working example. It would
> > save a lot of time for everybody and shrinks the number of round trips.
> 
> How can you tell that it works?  By testing your NRPZ driver?
> 

That is an option. But i will look for a more generic hardware. Maybe a
smartphone or a usb pen drive.


