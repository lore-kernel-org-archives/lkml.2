Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab2IKKUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:20:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:31607 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab2IKKT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:19:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,402,1344236400"; 
   d="scan'208";a="143730931"
Date: Tue, 11 Sep 2012 12:19:39 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: wm8994: Implement support for WM1811 devices with
 higher cust_ids
Message-ID: <20120911101939.GO3647@sortiz-mobl>
References: <1345733272-18570-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345733272-18570-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Aug 23, 2012 at 03:47:52PM +0100, Mark Brown wrote:
> Higher cust_ids have had the device revision field reset so need different
> handling of GPIO6.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8994-regmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
