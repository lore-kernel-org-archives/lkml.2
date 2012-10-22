Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab2JVWkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:40:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61265 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab2JVWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:40:16 -0400
Date: Mon, 22 Oct 2012 15:40:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Maxin B John <maxin.john@gmail.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support for OWI/Maplin USB Robotic Arm
Message-ID: <20121022224012.GB24489@kroah.com>
References: <20121008212943.GA3986@linux-3ix0.site>
 <20121008235503.GD8157@kroah.com>
 <CAMhs6YxeUJiqzMAj=zBCpZkivDsjHk7Td_Ov50uwFw8vv+qrrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMhs6YxeUJiqzMAj=zBCpZkivDsjHk7Td_Ov50uwFw8vv+qrrg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 11:52:56PM -0400, Maxin B John wrote:
> Hi Greg,
> 
> On Mon, Oct 8, 2012 at 7:55 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Oct 08, 2012 at 05:29:43PM -0400, Maxin B. John wrote:
> >> Hi Greg,
> >>
> >> This driver helps us to control the OWI/Maplin USB Robotic Arm device.
> >>
> >> I have tested this driver in my x86 Laptop and it works as expected
> >> (Some clean-ups and modifications are in the pipeline, though).
> >>
> >> After review process and the life in staging,I hope this driver will
> >> find it's place in "drivers/usb/misc/" :)
> >>
> >> The userspace utility program is available from the below URL:
> >> https://github.com/maxinbjohn/robotic_arm_driver
> >>
> >> OWI/Maplin USB Robotic arm is available from:
> >> http://www.maplin.co.uk/robotic-arm-kit-with-usb-pc-interface-266257
> >> http://www.owirobots.com/cart/html/owi-535pc-robotic-arm-kit-with-usb-pc-interface-assembled.html
> >>
> >> Please let me know your comments.
> >
> > Very nice, but are there any real requirement to have this be a kernel
> > driver, and not just be driven from userspace through libusb/usbfs
> > instead?
> 
> Thanks. A number of people are using the libusb based userspace
> applications to control these devices. This was an attempt to remove
> the libusb dependency and control the device easily like:
> # echo 1 > /sys/bus/usb/drivers/robotic_arm/5-1:1.0/led

I really think that libusb is the best way to control this device.  We
removed a bunch of drivers from the kernel a number of years ago that
could be better controlled by userspace.  Because of that, I can't take
this driver either.

Sorry,

greg k-h
