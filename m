Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab0DWPLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:11:12 -0400
Received: from kroah.org ([198.145.64.141]:50724 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab0DWPLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:11:10 -0400
Date: Fri, 23 Apr 2010 08:07:34 -0700
From: Greg KH <greg@kroah.com>
To: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: USBIP (staging) driver's dependency on drivers/usb/core
	internal headers
Message-ID: <20100423150734.GA7778@kroah.com>
References: <4BD179FB.3010309@VirtualLogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD179FB.3010309@VirtualLogix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 12:44:11PM +0200, Eric Lescouet wrote:
> Hi,
>
> The USBIP modules (and some others) have a direct dependency on the following headers:
> - drivers/usb/core/hdc.h (struct usb_hcd and various routines)
> - drivers/usb/core/hub.h (couple of constants)
> Because those headers are not part of include/, it makes it quite difficult
> to compile them as standalone modules (e.g.: against pre-compiled kernel).

Then don't do that :)

> hdc.c and hub.c are relatively self-contained and could be moved to e.g.: include/linux/usb/.
>
> What do you think?

I think the code needs to be cleaned up and merged to the main part of
the kernel tree, then this wouldn't be an issue, right?

Also, please cc: the linux-usb@vger.kernel.org list for USB related
things in the future.

thanks,

greg k-h
