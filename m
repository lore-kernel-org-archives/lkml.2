Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab1JMSWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:22:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59438 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756581Ab1JMSV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:21:59 -0400
Date: Thu, 13 Oct 2011 14:21:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Markus Rechberger <mrechberger@gmail.com>
cc: Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <CA+O4pC+kRXvGYpnHD7bocuL_t+YWLbChKg8kVAtxmMkd+60+CA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1110131417070.2026-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Markus Rechberger wrote:

> The same issues happen with MacOSX and AGAIN windows is also using the same
> buffer size.
> Currently there's only one sample available, the production should be
> ready by the end of this month.
> I can certainly give you one device for playing around as soon as it
> is ready but for that
> 
> Before that I insist that this patch will go into the kernel (I know
> that sounds ridiculous but so far I did everything
> you requested me to do), I clearly pointed out that we even have hardware
> specs which can influence the transfer buffer. The patch does not hurt
> and makes the device work.
> 
> Now it turns out that this issue suddenly is interesting because
> there's no idea why that can happen.
> First priority is to get this device work, second priority is
> everything else if Linux support is wanted.

For my part, I don't much mind raising the limit from 16 KB to 32 KB.  
48 KB may be unnecessary, especially since one of the devices doesn't 
even work when the transfer buffer is that large.

However it's just a work-around, not a real solution to the underlying
problem (whatever that problem turns out to be).  Part of the reason
for keeping the limit low is that it shouldn't matter, since people
ought to be able to use a bunch of small transfers rather than one
large transfer.  Apparently that justification doesn't work with these
webcams, although there's no known reason why it shouldn't.

But I'm not the person in charge of these decisions...

Alan Stern

