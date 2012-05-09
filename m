Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064Ab2EIPyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:54:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:25473 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067Ab2EIPyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:54:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="151024236"
Date: Wed, 9 May 2012 18:03:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: NeilBrown <neilb@suse.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/3] twl4030: enable wakeup on twl4030 IRQ.
Message-ID: <20120509160329.GP1794@sortiz-mobl>
References: <20120425025637.7832.14013.stgit@notabene.brown>
 <20120425030524.7832.66013.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425030524.7832.66013.stgit@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Wed, Apr 25, 2012 at 01:05:24PM +1000, NeilBrown wrote:
> Most of the interrupts that come through this line should trigger
> wakeups:
>   power button
>   RTC alarm
>   power available
>   usb plug/unplug
> 
> so mark the interrupt as a wakeup interrupt.
> This is particularly important for when the interrupt arrives during
> the late suspend phase.  Without this setting it will be ignored.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
> 
>  drivers/mfd/twl4030-irq.c |    1 +
>  1 file changed, 1 insertion(+)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
