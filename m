Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab2K3KwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:52:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:35822 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab2K3KwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:52:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="255492584"
Date: Fri, 30 Nov 2012 11:52:09 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@linaro.org, srinidhi.kasagar@stericsson.com,
        patches@linaro.org
Subject: Re: [PATCH] mfd: ab8500-core: Fix invalid free of devm_ allocated
 data
Message-ID: <20121130105209.GL3176@sortiz-mobl>
References: <1353673123-32340-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353673123-32340-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tushar,

On Fri, Nov 23, 2012 at 05:48:43PM +0530, Tushar Behera wrote:
> The objects allocated by devm_* APIs are managed by devres and are
> freed when the device is detached. Hence there is no need to remove
> them explicitly in remove function.
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/mfd/ab8500-core.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
