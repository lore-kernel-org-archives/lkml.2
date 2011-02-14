Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1BNPXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:23:37 -0500
Received: from kroah.org ([198.145.64.141]:57836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab1BNPXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:23:35 -0500
Date: Mon, 14 Feb 2011 07:23:12 -0800
From: Greg KH <greg@kroah.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        John Williams <john.williams@petalogix.com>
Subject: Re: [PATCH] of: Add missing of_address.h to xilinx ehci driver
Message-ID: <20110214152312.GA15003@kroah.com>
References: <1297680009-4054-1-git-send-email-monstr@monstr.eu>
 <AANLkTi=GZdX62bbMQhE81rbXO0MBdTK-pPbF61qEX3C+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=GZdX62bbMQhE81rbXO0MBdTK-pPbF61qEX3C+@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 06:54:08AM -0700, Grant Likely wrote:
> On Mon, Feb 14, 2011 at 3:40 AM, Michal Simek <monstr@monstr.eu> wrote:
> > Build log:
> > In file included from drivers/usb/host/ehci-hcd.c:1208:
> > drivers/usb/host/ehci-xilinx-of.c: In function 'ehci_hcd_xilinx_of_probe':
> > drivers/usb/host/ehci-xilinx-of.c:168: error: implicit declaration of function 'of_address_to_resource'
> >
> > Signed-off-by: John Williams <john.williams@petalogix.com>
> > Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> Greg, let me know if you want me to pick this one up for my next pull req.

Sure, please do that, it makes a bit more sense for you to take it if
you need to.

  Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

thanks,

greg k-h
