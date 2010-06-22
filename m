Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0FVWl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 18:41:58 -0400
Received: from kroah.org ([198.145.64.141]:58097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab0FVWls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 18:41:48 -0400
Date: Tue, 22 Jun 2010 15:39:13 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH v2] Staging: dt3155: Cleanup memory mapped i/o access
Message-ID: <20100622223913.GA28119@kroah.com>
References: <20100504025430.GA26421@suse.de>
 <1273000031.4143.56.camel@Joe-Laptop.home>
 <0D753D10438DA54287A00B0270842697636EB83CE8@AUSP01VMBX24.collaborationhost.net>
 <20100504201207.GA7096@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83E2A@AUSP01VMBX24.collaborationhost.net>
 <20100504210229.GA21128@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83EC9@AUSP01VMBX24.collaborationhost.net>
 <0D753D10438DA54287A00B0270842697636ECB4D7B@AUSP01VMBX24.collaborationhost.net>
 <20100506202535.GA28600@kroah.com>
 <0D753D10438DA54287A00B027084269763715265FE@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269763715265FE@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 10:51:54AM -0500, H Hartley Sweeten wrote:
> The macros ReadMReg and WriteMReg are really just private versions of
> the kernel's readl and writel functions.  Use the kernel's functions
> instead.  And since ioremap returns a (void __iomem *) not a (u8 *),
> change all the uses of dt3155_lbase to reflect this.
> 
> While here, make dt3155_lbase static since it is only used in the
> dt3155_drv.c file.  Also, remove the global variable dt3155_bbase
> since it is not used anywhere in the code.
> 
> Where is makes sense, create a local 'mmio' variable instead of using
> dt3155_lbase[minor] to make the code more readable.
> 
> This change also affects the {Read|Write}I2C functions so they are
> also modified as needed.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Scott Smedley <ss@aao.gov.au>
> 
> ---
> 
> V2 - rebased to next-20100621

You are still doing something odd, this one doesn't apply either.  Is
your email client messing something up?

strange.

greg k-h
