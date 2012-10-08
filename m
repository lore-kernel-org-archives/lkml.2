Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab2JHXzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:55:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54352 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2JHXzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 19:55:07 -0400
Date: Mon, 8 Oct 2012 16:55:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support for OWI/Maplin USB Robotic Arm
Message-ID: <20121008235503.GD8157@kroah.com>
References: <20121008212943.GA3986@linux-3ix0.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121008212943.GA3986@linux-3ix0.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 05:29:43PM -0400, Maxin B. John wrote:
> Hi Greg,
> 
> This driver helps us to control the OWI/Maplin USB Robotic Arm device.
> 
> I have tested this driver in my x86 Laptop and it works as expected
> (Some clean-ups and modifications are in the pipeline, though).
> 
> After review process and the life in staging,I hope this driver will
> find it's place in "drivers/usb/misc/" :)
> 
> The userspace utility program is available from the below URL:
> https://github.com/maxinbjohn/robotic_arm_driver
> 
> OWI/Maplin USB Robotic arm is available from:
> http://www.maplin.co.uk/robotic-arm-kit-with-usb-pc-interface-266257
> http://www.owirobots.com/cart/html/owi-535pc-robotic-arm-kit-with-usb-pc-interface-assembled.html
> 
> Please let me know your comments.

Very nice, but are there any real requirement to have this be a kernel
driver, and not just be driven from userspace through libusb/usbfs
instead?

thanks,

greg k-h
