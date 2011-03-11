Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab1CKQQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:16:53 -0500
Received: from kroah.org ([198.145.64.141]:52665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab1CKQQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:16:49 -0500
Date: Fri, 11 Mar 2011 08:14:21 -0800
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311161421.GA7843@kroah.com>
References: <4D79F068.2080009@linaro.org>
 <201103111331.13932.arnd@arndb.de>
 <20110311152938.GB29920@sirena.org.uk>
 <201103111654.04089.arnd@arndb.de>
 <20110311160308.GQ1760@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311160308.GQ1760@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 04:03:09PM +0000, Mark Brown wrote:
> On Fri, Mar 11, 2011 at 04:54:03PM +0100, Arnd Bergmann wrote:
> > On Friday 11 March 2011, Mark Brown wrote:
> 
> > > It's arguable if this stuff is broken at all, from a hardware design
> > > point of view it's perfectly reasonable and if you're shipping volumes
> > > in the millions very small savings add up to interesting numbers easily.
> 
> > It may be reasonable if you don't expect anyone to connect the
> > device to an ethernet port, but in that case you could save much
> > more by removing the ethernet chip and the socket along with the
> > eeprom.
> 
> > Really, any machine without a fixed MAC address is a huge pain
> > for users, just google for "pandaboard mac address" to see
> > how much work this has caused people.
> 
> I'm not familiar with the Pandaboard but most of the devices I've worked
> with that do this have unique MAC addresses but they store in other
> locations on the device (typically in flash).
> 
> Like I say, it's not just MAC addresses that can need configuring this
> way - it can be other random "you're wired up this way" type
> information that would normally be figured out from the USB IDs.

And all of that should be done in userspace, like all other device
names, I still fail to see what is so different here from any other type
of system.

thanks,

greg k-h
