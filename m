Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab2DZPGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:06:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52780 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757476Ab2DZPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:06:46 -0400
Date: Thu, 26 Apr 2012 11:06:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] USB: remove CONFIG_USB_DEVICEFS
In-Reply-To: <20120426001529.GA14006@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1204261103120.1530-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012, Greg Kroah-Hartman wrote:

> This option has been deprecated for many years now, and no userspace
> tools use it anymore, so it should be safe to finally remove it.
> 
> Reported-by: Kay Sievers <kay@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
> Anyone object to me queuing this up for the 3.5 kernel release?

I'm not sure about this.  There are a few systems still floating around
that don't use udev; on those systems /proc/bus/usb is the only way for 
user programs to control USB devices.  Admittedly, I have no idea 
whether any such systems will be using 3.5 or later kernels...

Alan Stern

