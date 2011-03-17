Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab1CQWyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:54:33 -0400
Received: from kroah.org ([198.145.64.141]:36601 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716Ab1CQWy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:54:29 -0400
Date: Thu, 17 Mar 2011 15:53:28 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110317225328.GB31581@kroah.com>
References: <20110311165642.GA9996@kroah.com>
 <20110317214042.GQ31411@opensource.wolfsonmicro.com>
 <20110317214736.GA29014@kroah.com>
 <201103172333.01474.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103172333.01474.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 11:33:01PM +0100, Arnd Bergmann wrote:
> On Thursday 17 March 2011 22:47:36 Greg KH wrote:
> > > > Patches to fix this, for this specific PandaBoard controller are gladly
> > > > accepted.  What's odd is this is explicitly a Linux development board,
> > > > so you would think that this could have been caught, and fixed, in the
> > > > hardware a long time ago, right?
> > > 
> > > The way everyone resolves this stuff is by patching their kernel
> > > locally.
> > 
> > Well, that means that the device tree work is going to be useful here,
> > right?  :)
> 
> I like the idea. Let's make this the first use case where a lot of
> people will want to have the device tree on ARM. The patch to the
> driver to check for a mac-address property is trivial, and we
> can probably come up with a decent way of parsing the device
> tree for USB devices, after all there is an existing spec for
> it (http://playground.sun.com/1275/bindings/usb/usb-1_0.ps).
> 
> 	Arnd
> 
> 8<------
> [PATCH] net/smscx5xx: demonstrate use of device tree for mac address
> 
> This takes the MAC address for smsc75xx/smsc95xx USB network devices
> from a the device tree. This is required to get a usable persistent
> address on the popular beagleboard, whose hardware designers
> accidentally forgot that an ethernet device really requires an a
> MAC address to be functional.
> 
> The smsc75xx and smsc95xx drivers are just two copies of the
> same code, so better fix both.
> 
> Not tested!
> 
> Signed-off-by: Arnd Bergmann <arnd.bergmann@linaro.org>

<snip>

Very nice.

Andy and Mark, would this patch work for you?

thanks,

greg k-h
