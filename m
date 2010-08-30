Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0H3Wpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 18:45:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab0H3Wpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 18:45:41 -0400
Date: Mon, 30 Aug 2010 15:45:28 -0700
From: Greg KH <gregkh@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: New staging driver for Realtek RTL8192 USB device
Message-ID: <20100830224528.GA2775@suse.de>
References: <4C7B2379.7040705@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7B2379.7040705@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 10:20:25PM -0500, Larry Finger wrote:
> Greg,
> 
> Realtek has finally given me permission to submit the driver named r8712u for
> the RTL8192 USB device.

Yeah!!!!

> My first question is how do you want to get the info. I have it in a git tree at
> kernel.org if you want to pull from there, otherwise, I can generate a single
> massive patch, or a set of smaller patches. Please advise me.

I can pull from a git tree for staging-next just fine, just point me at
it and I can do the rest.

> A second question will be how to handle the driver for this device that is now
> in drivers/staging/rtl8192su/. My suggestion would be to remove it, but I'll
> leave that to you.

I will be glad to delete it after I pull your driver in, sound good?

thanks,

greg k-h
