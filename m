Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281Ab1ETAA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:00:29 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55295 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756025Ab1ETAA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:00:26 -0400
X-Sasl-enc: mldStyBcKx7a+Nm/rbVm+9/6D0nVMejQT5GG+yJ5tNZk 1305849625
Date: Thu, 19 May 2011 17:00:13 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfm@muteddisk.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: replace usbip_u{dbg,err,info} and printk
 with dev_ and pr_
Message-ID: <20110520000013.GA8908@kroah.com>
References: <2db81796703063c0816d0d99040c6fbd6da50007.1305847719.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2db81796703063c0816d0d99040c6fbd6da50007.1305847719.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 04:47:32PM -0700, matt mooney wrote:
> This switches all of the usbip_u{dbg,err,info} and printk statements to
> dev_<level>, if possible, or pr_<level> macros. And removes a few
> unnecessary debug statements.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---
> Hi Greg,
> 
> Not as many of these could be changed to dev_* as I had initially
> thought. A few were not changed to dev_* that could have possibly been
> due to the struct device being deeply embedded within another
> structure. I did not want to introduce any null pointer deferences, so
> I played it safe for the time being. But as development continues I
> will modify these.

Ok, that's fine.

> I also wonder if anybody is currently using usbip because I get a kernel
> crash on the remote side everytime I try to attach an exported device.
> Of course, I am running the remote and host machines through kvm, but I
> don't think that should make a difference. Anyway, I thought you should
> know so that if this comes up, you know that it was in this state before
> any of my changes ;)

I have gotten a few reports of it not working right now, but no one
stepped up and debugged it.

If you could do that now, that would be great, as it would be nice to
have a working base to go off of :)

Also, the merge window for the .40 tree for the staging tree is now
closed, so I'll only take bugfixes for the usbip code for now.

thanks,

greg k-h
