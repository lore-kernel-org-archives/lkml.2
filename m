Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1EVUyO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:54:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:2984 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1EVUyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:54:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,253,1304319600"; 
   d="scan'208";a="5589234"
Date: Sun, 22 May 2011 22:53:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gadiyar@ti.com, parthab@india.ti.com
Subject: Re: [RESEND][PATCH 4/5] arm: omap: usb: Runtime PM support
Message-ID: <20110522205353.GK18610@sortiz-mobl>
References: <1305538732-21087-1-git-send-email-keshava_mgowda@ti.com>
 <20110518104806.GB13908@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518104806.GB13908@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Wed, May 18, 2011 at 01:48:09PM +0300, Felipe Balbi wrote:
> On Mon, May 16, 2011 at 03:08:52PM +0530, Keshava Munegowda wrote:
> > From: Keshava Munegowda <Keshava_mgowda@ti.com>
> > 
> > The usbhs core driver does not enable/disable the intefrace and
> > fucntional clocks; These clocks are handled by hwmod and runtime pm,
> > hence insted of the clock enable/disable, the runtime pm APIS are
> > used. however,the port clocks and tll clocks are handled
> > by the usbhs core.
> > 
> > Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> 
> Samuel how do we solve this series ? I can take the arch/arm/*omap*/
> patches through Tony's tree, can you take the drivers/mfd/* via you
> tree ?
I'm taking this one. Let's hope the conflicts are not too bad.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
