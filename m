Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab2I3W5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 18:57:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:51208 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab2I3W5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 18:57:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,514,1344236400"; 
   d="scan'208";a="228378181"
Date: Mon, 1 Oct 2012 00:56:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Matthias Kaehlcke <matthias@kaehlcke.net>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: tps65217_bl: Add missing platform_set_drvdata
 in tps65217_bl_probe
Message-ID: <20120930225647.GD12231@sortiz-mobl>
References: <1349000906.28456.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349000906.28456.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Sun, Sep 30, 2012 at 06:28:26PM +0800, Axel Lin wrote:
> Otherwise, we got NULL derefernce while calling backlight_device_unregister()
> in tps65217_bl_remove().
> 
> Also convert to use module_platform_driver.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/video/backlight/tps65217_bl.c |   14 ++------------
>  1 file changed, 2 insertions(+), 12 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
