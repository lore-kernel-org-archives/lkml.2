Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917Ab2EITw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:52:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:24451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab2EITw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:52:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142022306"
Date: Wed, 9 May 2012 22:02:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org, Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH] MFD: twl6040: Add regulator support for VIO, V2V1
 supplies
Message-ID: <20120509200206.GA17206@sortiz-mobl>
References: <1335966882-19897-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335966882-19897-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, May 02, 2012 at 04:54:42PM +0300, Peter Ujfalusi wrote:
> twl6040 has three power supply source:
> VBAT needs to be connected to VBAT, VIO, and V2V1.
> Add regulator support for the VIO, V2V1 supplies.
> Initially handle the two supply together with bulk commands.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/twl6040-core.c  |   33 +++++++++++++++++++++++++++++----
>  include/linux/mfd/twl6040.h |    2 ++
>  2 files changed, 31 insertions(+), 4 deletions(-)
> 
> Hi Samuel,
> 
> The runtime dependencies for this patch has been sent to linux-omap list:
> http://marc.info/?l=linux-omap&m=133596645010228&w=2
> http://marc.info/?l=linux-omap&m=133596645610232&w=2
> http://marc.info/?l=linux-omap&m=133596644310224&w=2
> http://marc.info/?l=linux-omap&m=133596643310220&w=2
> 
> Alone this patch does not cause compile time regression but in runtime it needs
> the arch/arm/mach-omap2 patches.
> I try to avoid cross tree issues as much as I can and I'm happy if these will
> come together in linux-next (and finally in 3.5).
I applied this one to my nfc-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
