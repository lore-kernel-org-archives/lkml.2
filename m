Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1CQWU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:20:26 -0400
Received: from kroah.org ([198.145.64.141]:38320 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab1CQWUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:20:24 -0400
Date: Thu, 17 Mar 2011 15:20:20 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110317222020.GA30486@kroah.com>
References: <20110311161421.GA7843@kroah.com>
 <20110317201835.GM31411@opensource.wolfsonmicro.com>
 <20110317202614.GA3155@kroah.com>
 <201103172311.36246.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103172311.36246.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 11:11:36PM +0100, Arnd Bergmann wrote:
> On Thursday 17 March 2011 21:26:14 Greg KH wrote:
> > > It's going to be an off the shelf USB ethernet controller.  I'd be
> > > astonished if the board-configurable device IDs weren't set from the
> > > same SEPROM that the MAC address is so it'd just show up as a generic
> > > chip of whatever kind.
> > 
> > Huh?  All USB controllers you buy have the ability to set the vendor and
> > product id, so you should always be able to key off of that.
> > 
> > Isn't that the case here?
> 
> The same EEPROM that is missing here carries both the MAC address and
> the vendor/product ID overrides.

{sigh}

It's as if BIOS programmers are now laying out board designs...
