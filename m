Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab1CRPPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:15:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56725 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752486Ab1CRPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:15:11 -0400
Date: Fri, 18 Mar 2011 15:15:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: andy.green@linaro.org, Greg KH <greg@kroah.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110318151508.GC677@opensource.wolfsonmicro.com>
References: <20110311165642.GA9996@kroah.com>
 <201103172333.01474.arnd@arndb.de>
 <4D82979B.2050003@linaro.org>
 <201103181600.09877.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103181600.09877.arnd@arndb.de>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 04:00:09PM +0100, Arnd Bergmann wrote:
> On Friday 18 March 2011, Andy Green wrote:

> > What's the plan for leveraging that level of generality on "dynamically 
> > probed devices"?  I mean I know what I want to use this for and the 
> > platform_data scheme covers all the soldered-on-the-board cases fine.

> Isn't there also a device tree based OMAP tree that can boot on
> Panda and is just waiting to get merged?

Did the stuff with multiple interrupt controllers get resolved?  That's
pretty important for practical use.  There have been quite a few
iterations of the device tree patches for ARM over the last release but
the iterations I looked at all seemed to be bugfix type stuff.
