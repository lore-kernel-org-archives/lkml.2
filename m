Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0GVXzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:55:17 -0400
Received: from kroah.org ([198.145.64.141]:54209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab0GVXzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:55:15 -0400
Date: Thu, 22 Jul 2010 16:46:30 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        stable <stable@kernel.org>
Subject: Re: [PATCHv4 1/5] USB: gadget: composite: Better string override
 handling
Message-ID: <20100722234630.GA1352@kroah.com>
References: <e2d14d0a730dde4b716c0e086761ef65ba9afda8.1278619472.git.m.nazarewicz@samsung.com>
 <89baa7d196b5e1d8427c90a78f2aa0cda4331d7a.1279794289.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89baa7d196b5e1d8427c90a78f2aa0cda4331d7a.1279794289.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 02:16:33PM +0200, Michal Nazarewicz wrote:
> The iManufatcurer, iProduct and iSerialNumber composite module
> parameters are only used when the gadget driver registers
> strings for manufacturer, product and serial number.  If the
> gadget never bothered to set corresponding fields in USB
> device descriptors those module parameters are ignored.
> 
> This patch makes the parameters even if the strings ID have
> not been assigned.  It also changes the way IDs are
> overridden -- what IDs are overridden is now saved in
> usb_composite_dev structure -- which makes it unnecessary to
> modify the string tables the way previous code did.

David, do these look better?

And they are not -stable material, no matter what, sorry, so you can
stop copying stable@kernel.org on them.

thanks,

greg k-h
