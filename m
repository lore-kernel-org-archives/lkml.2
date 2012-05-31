Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2EaMEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:04:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44213 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab2EaMEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:04:21 -0400
Date: Thu, 31 May 2012 20:04:11 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        thomas.braunstorfinger@rohde-schwarz.com
Subject: Re: [PATCH] add new NRP power meter USB device driver
Message-ID: <20120531120411.GA4859@kroah.com>
References: <1338318858-24144-1-git-send-email-stefani@seibold.net>
 <1338454041.6454.67.camel@wall-e>
 <20120531095304.GA3884@kroah.com>
 <201205311217.11692.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205311217.11692.oneukum@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 12:17:11PM +0200, Oliver Neukum wrote:
> Am Donnerstag, 31. Mai 2012, 11:53:04 schrieb Greg KH:
> > > So it is a chicken and egg problem. A lot of software is now out with
> > > depends on this driver and a lot of embedded development environments
> > > doesn't provide libudev, libsysfs und libusb. It will also increase the
> > > size of the image and adds additional dependencies to the application.
> > 
> > You don't need any of those libraries to do this.  What's wrong with
> > using "raw" usbfs interactions?
> 
> SPI is not limited to USB. If we can get a unified subsystem then the
> drivers need to be in kernel space, as some hardware does not allow
> a solution in user space.

Ok, now that is a valid reason for a kernel driver.

But, I think it should use the IIO interface, as that should handle
these types of devices.

thanks,

greg k-h
