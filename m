Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab2K1WnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:43:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:40034 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab2K1WnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:43:15 -0500
Date: Wed, 28 Nov 2012 14:43:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: drivres/hv
Message-ID: <20121128224313.GA14402@kroah.com>
References: <1354133850-17540-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354133850-17540-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 12:17:30PM -0800, K. Y. Srinivasan wrote:
>  
> Greg,

You are writing the most unhelpful Subject: lines lately, please be more
descriptive in the future.

> I recently discovered that the Hyper-V host allocates mmio
> memory for some synthetic devices like the virtual framebuffer.
> We are currently in the process of implementing this virtual
> framebuffer device. As part of the offer message from the host
> we are given the mmio region size that needs to be allocatted to
> the device. I am told in the current implementation of the firmware,
> this mmio resource shows up in the PCI space. What is the best way to
> allocate this mmio space for this driver.

I don't understand, does the guest os think this really is mmio memory
and the host just set up up?  Or is the memory being used to pass data
back and forth?  Or something else?

And what do you mean "firmware"?  That usually means UEFI/BIOS to me,
not a hyperv host.

And finally, what does the guest os see as far as the PCI resource space
shows it?  Shouldn't it just think it is a normal PCI device and access
it properly that way?

thanks,

greg k-h
