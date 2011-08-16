Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1HPNu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:50:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57525 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1HPNuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:50:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6439"; a="110658949"
Date: Tue, 16 Aug 2011 06:50:51 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kenneth Heitke <kheitke@codeaurora.org>, davidb@codeaurora.org,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20110816135051.GA22227@huya.qualcomm.com>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
 <201108111455.56319.arnd@arndb.de>
 <20110812164608.GC28150@sirena.org.uk>
 <201108161537.28612.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108161537.28612.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 03:37:28PM +0200, Arnd Bergmann wrote:
> On Friday 12 August 2011, Mark Brown wrote:
> > On Thu, Aug 11, 2011 at 02:55:55PM +0200, Arnd Bergmann wrote:
> > > On Thursday 11 August 2011, Kenneth Heitke wrote:
> > 
> > > > +EXPORT_SYMBOL_GPL(slim_add_device);
> > 
> > > I don't think this should be exported: AFAICT, the set of slim_devices
> > > is a property of the platform, so I don't see how any other device driver
> > > would add another device.
> > 
> > The platform may be comprised of multiple hardwaare modules with
> > functionality on daughtercards which can be probed at runtime.  You may
> > also find someone constructing a PCI card or something with a slimbus
> > controller on it at some point.
> 
> This is theoretically true, but IIRC David mentioned that the bus is
> only present on few SoCs and has since been abandoned in favor of standard
> busses for new devices.

Actually, this is a different one than the one I was mentioning at the
Linaro Connect.  I believe SLIMbus is more active
http://en.wikipedia.org/wiki/SLIMbus

The other bus I was mentioning is called SSBI, which as far as I know
is only used to communicate between MSMs and certain Qualcomm
peripheral chips.

Kenneth would better be able to clarify how dynamic the SLIMbus is.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
