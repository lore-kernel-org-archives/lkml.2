Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab2EEOw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:52:28 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:57757 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab2EEOw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:52:26 -0400
Date: Sat, 5 May 2012 07:52:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: also announce bcdDevice
Message-ID: <20120505145224.GA27469@kroah.com>
References: <1336218719.8450.19.camel@x61.thuisdomein>
 <4FA519B3.9030901@fold.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA519B3.9030901@fold.natur.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 02:14:43PM +0200, Martin Mokrejs wrote:
> Paul Bolle wrote:
> > Currently announce_device() does print the idVendor and idProduct values
> > but does not print the bcdDevice value. USB devices are accurately
> > identified by all three values. See, for instance, the USB storage
> > quirks which will only apply for a certain (range of) bcdDevice
> > value(s). So it seems useful to also print bcdDevice when announcing USB
> > devices.
> 
> Could it also report negotiated speed? full-speed, high-speed, super-speed?

All of this, including the bcdDevice, can be found in sysfs.  So I don't
want to take this patch, otherwise we would be just adding more and more
to the kernel log.

If you programatically want to find this out, use libudev or listen to
the dbus messages for new devices, don't watch the kernel log messages.

thanks,

greg k-h
