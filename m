Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab1FQOfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:35:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59961 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759152Ab1FQOfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:35:32 -0400
Date: Fri, 17 Jun 2011 10:35:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: ablay@codeaurora.org
cc: Greg KH <greg@kroah.com>, Felipe Balbi <balbi@ti.com>,
        Tatyana Brokhman <tlinder@codeaurora.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to 
     devio.c
In-Reply-To: <8196aa784ab3686cb19581131df0be16.squirrel@www.codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1106171033320.2143-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 ablay@codeaurora.org wrote:

> My name is Amit Blay, I'm working with Tatyana Brokhman, I originally
> created this patch. I want to make sure I understand the solution:
> 
> We will create a new IOCTL, i.e., USBDEVFS_SUBMITURB_SS. This IOCTL will
> pass new URB structure, usbdevfs_urb_ss, which will hold the "legacy" URB
> and in addition the stream_id. libusb will be able to use the new ABI
> whenever SuperSpeed streams are required.
> 
> Is this correct?

This probably should be USBDEVFS_SUBMITURB_STREAM, since it is necesary
only for URBs that use bulk streaming rather than for all SuperSpeed
URBs.

Alan Stern

