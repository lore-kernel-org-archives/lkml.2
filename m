Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2ATQCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:02:19 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42774 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532Ab2ATQCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:02:17 -0500
X-Sasl-enc: LUErHc5xsI/bMszXaD5ppE28Kc2s39MCXRF2Pjsfxxn1 1327075337
Date: Fri, 20 Jan 2012 11:02:10 -0500
From: Greg KH <greg@kroah.com>
To: Padfoot <padfoot@exemail.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Kernel version 3.2.1 usb touchscreen device not
 recognised [UDEV? USBINPUT? HOOK]
Message-ID: <20120120160210.GA21565@kroah.com>
References: <4F192242.1070909@exemail.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F192242.1070909@exemail.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 07:13:54PM +1100, Padfoot wrote:
> Upgrade from kernel 3.1.9 to 3.2.1 eGalax usb touchscreen device is
> no longer recognised.
> 
> Device is an Acer Iconia Tab w501 with inbuilt touchscreen. Screen
> is a pci device but is connected on boot as a usb input device.
> Issue appears to be with either UDEV or USBINPUT boot hook failing
> to recognise the device as can be seen in the dmesg.3.2.1
> attachment.
> 
> Downgrading to kernel 3.1.9 corrects the issue.

Can you run 'git bisect' between 3.1.0 and 3.2.0 to find the problem
commit here?

Also, you might want to cc: the linux-input developers, they can help
you out much better than the general list can.

greg k-h
