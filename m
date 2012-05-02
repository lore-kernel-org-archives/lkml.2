Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2EBHqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 03:46:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:21097 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2EBHqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 03:46:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="136035034"
Date: Wed, 2 May 2012 09:46:32 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>,
        lkml <linux-kernel@vger.kernel.org>, "Bergmann, Arnd" <arnd@arndb.de>
Subject: Re: omap-usb-host.c compile error
Message-ID: <20120502074632.GG20224@sortiz-mobl>
References: <4FA056A1.1040209@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA056A1.1040209@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Tue, May 01, 2012 at 02:33:21PM -0700, John Stultz wrote:
> 
> I've been seeing the following compile issue for a few -rcs now:
> drivers/mfd/omap-usb-host.c: In function 'omap_usbhs_init':
> drivers/mfd/omap-usb-host.c:524: error: implicit declaration of
> function 'cpu_is_omap3430'
> drivers/mfd/omap-usb-host.c:524: error: implicit declaration of
> function 'omap_rev'
> drivers/mfd/omap-usb-host.c:524: error: 'OMAP3430_REV_ES2_1'
> undeclared (first use in this function)
> drivers/mfd/omap-usb-host.c:524: error: (Each undeclared identifier
> is reported only once
> drivers/mfd/omap-usb-host.c:524: error: for each function it appears in.)
> 
> Reverting 1fcb57d0f6e1150003d222051aaaf4bc4a9ccc94 seems to resolve it.
> 
> This still isn't fixed in Linus' HEAD. Any plans here?
I pushed the fixed to my for-linus branch yesterday. I'll send a pull request
to Linus in time for rc6.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
