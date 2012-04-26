Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2DZPMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:12:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58153 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499Ab2DZPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:12:46 -0400
Date: Thu, 26 Apr 2012 08:12:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] USB: remove CONFIG_USB_DEVICEFS
Message-ID: <20120426151242.GA14774@kroah.com>
References: <20120426001529.GA14006@kroah.com>
 <Pine.LNX.4.44L0.1204261103120.1530-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204261103120.1530-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 11:06:45AM -0400, Alan Stern wrote:
> On Wed, 25 Apr 2012, Greg Kroah-Hartman wrote:
> 
> > This option has been deprecated for many years now, and no userspace
> > tools use it anymore, so it should be safe to finally remove it.
> > 
> > Reported-by: Kay Sievers <kay@vrfy.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> > Anyone object to me queuing this up for the 3.5 kernel release?
> 
> I'm not sure about this.  There are a few systems still floating around
> that don't use udev; on those systems /proc/bus/usb is the only way for 
> user programs to control USB devices.  Admittedly, I have no idea 
> whether any such systems will be using 3.5 or later kernels...

They don't have to use udev, they can use devtmpfs (which is what the
majority of embedded systems use today), or they can just use static
device nodes to get access to these devices, the char node is still
present, we aren't getting rid of them at all.

thanks,

greg k-h
