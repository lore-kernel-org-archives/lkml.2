Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2DBSFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:05:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39903 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab2DBSFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:05:48 -0400
Date: Mon, 2 Apr 2012 11:05:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Brenner <jbrenner@TAOSinc.com>
Cc: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: TAOS Color sensor
Message-ID: <20120402180544.GA21374@kroah.com>
References: <B4B07CCC7B7A084E989CF9386538EA1D0120B2C6@exchsrvr.taosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B4B07CCC7B7A084E989CF9386538EA1D0120B2C6@exchsrvr.taosinc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 12:28:39PM -0500, Jon Brenner wrote:
> There is a need to release a driver for the TAOS tsl3x7x family of COLOR
> sensors.
> The driver provides Lux (clear and IR) , Proximity, Color temperature
> (calculated CCT) and raw - red, green, and blue data channels.
> Currently I do not think the IIO subsystem provides for CT or RGB data
> channels.
> Is this correct?
> What can be done to accommodate it and who can do it?

Do you have a driver written already for this?  What is the interface to
the device?  If this can this use the v4l layer to get the color channel
information out to userspace?

Or is this needed to be done in the kernel at all, lots of color sensors
are driven by libusb today, like the one on my desk at the moment, no
kernel changes needed at all.

thansk,

greg k-h
