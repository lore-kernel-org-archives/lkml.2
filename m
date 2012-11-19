Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab2KSAUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 19:20:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:57477 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2KSAUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 19:20:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,275,1352102400"; 
   d="scan'208";a="169930613"
Date: Mon, 19 Nov 2012 01:20:27 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] mfd: Only unregister platform devices allocated by
 the mfd core
Message-ID: <20121119002027.GC18738@sortiz-mobl>
References: <20121109161528.GA674@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121109161528.GA674@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Charles,

On Fri, Nov 09, 2012 at 04:15:28PM +0000, Charles Keepax wrote:
> mfd_remove_devices would iterate over all devices sharing a parent with
> an mfd device regardless of whether they were allocated by the mfd core
> or not. This especially caused problems when the device structure was
> not contained within a platform_device, because to_platform_device is
> used on each device pointer.
> 
> This patch defines a device_type for mfd devices and checks this is
> present from mfd_remove_devices_fn before processing the device.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/mfd-core.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
Thanks a lot, patch applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
