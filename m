Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1HVOwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:52:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:14159 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab1HVOwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:52:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,263,1312182000"; 
   d="scan'208";a="41101057"
Date: Mon, 22 Aug 2011 16:54:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/7] twl4030: finish threaded IRQ conversion
Message-ID: <20110822145436.GW4607@sortiz-mobl>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
 <20110709040900.GI26900@sirena.org.uk>
 <20110818213614.GB20509@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818213614.GB20509@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Fri, Aug 19, 2011 at 12:36:15AM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Sat, Jul 09, 2011 at 05:09:00AM +0100, Mark Brown wrote:
> > On Thu, Jun 30, 2011 at 12:51:03PM +0300, Felipe Balbi wrote:
> > 
> > > the following patches where boot-tested on beagle xM
> > > and everything seems fine. MMC root filesystem still
> > > mounts, /proc/interrupts looks like ps aux | grep irq
> > > shows our threads, etc.
> > 
> > Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> It has been a long time and nobody complained. Samuel, can you take
> these patches in for 3.2 merge window ?
Yes, that sounds like the right time now.
All 7 patches applied, many thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
