Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0JJMzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 08:55:12 -0400
Received: from kroah.org ([198.145.64.141]:36236 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095Ab0JJMzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 08:55:10 -0400
Date: Sun, 10 Oct 2010 05:41:59 -0700
From: Greg KH <greg@kroah.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nohee Ko <noheek@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/3] staging: brcm80211: clean up custom ctype library
	again
Message-ID: <20101010124159.GA21776@kroah.com>
References: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 01:20:11PM +0300, Andy Shevchenko wrote:
> The similar cleanup was done before for softmac implementation.  But the
> fullmac driver brings this back. Remove it again.
> 
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> ---
>  drivers/staging/brcm80211/brcmfmac/bcmutils.c |   56 ++----------------------

This file is now gone from the tree, as of yesterday.  Care to resync on
the next linux-next tree on Monday and verify if any of these patches
are even needed anymore?

thanks,

greg k-h
