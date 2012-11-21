Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab2KUQxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:53:19 -0500
Received: from mga14.intel.com ([143.182.124.37]:55159 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab2KUQxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:53:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="scan'208";a="171060142"
Date: Wed, 21 Nov 2012 17:52:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Inderpal Singh <inderpal.singh@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH] MFD: SEC: Fix reg_offset for interrupt registers
Message-ID: <20121121165258.GD18738@sortiz-mobl>
References: <1350454735-17697-1-git-send-email-inderpal.singh@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350454735-17697-1-git-send-email-inderpal.singh@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Inderpal,

On Wed, Oct 17, 2012 at 11:48:55AM +0530, Inderpal Singh wrote:
> reg_offset is offset of the status/mask registers. Now, since status_base
> and mask_base are pointing to corresponding first registers, reg_offset
> should start from 0 otheriwse regmap_add_irq_chip will fail during probe.
> 
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
> ---
> It is based on Samuel's for-next-merge branch of mfd-2.6 tree. 
> 
>  drivers/mfd/sec-irq.c |  102 ++++++++++++++++++++++++-------------------------
>  1 file changed, 51 insertions(+), 51 deletions(-)
I queued this one to my for-linus branch since it basically prevents IRQs from
working here. But it seems weird that such a mistake was not caught earlier.
So I'd like to get Sangbeom's ACK before pushing this one upstream.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
