Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2KUNhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:37:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:19932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab2KUNhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:37:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="scan'208";a="222635030"
Date: Wed, 21 Nov 2012 14:37:43 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RESEND 0/5] mfd: tps65090: cleanups and use regmap-irq
 for interrupt support
Message-ID: <20121121133743.GQ18738@sortiz-mobl>
References: <1353381289-11643-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353381289-11643-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Tue, Nov 20, 2012 at 08:44:44AM +0530, Laxman Dewangan wrote:
> This patch series cleanups the driver code by removing unused
> member, rearranging code and moving irq implementation to regmap-irq
> framework.
> 
> Just resending in case of it is missed.
> 
> Laxman Dewangan (5):
>   mfd: add battery charger in tps65090 sub devs
>   mfd: tps65090: add error prints when mem alloc failed
>   mfd: tps65090: remove unused member of struct tps65090
>   mfd: tps65090: move register access APIs to header
>   mfd: tps65090: use regmap irq framework for interrupt support
> 
>  drivers/mfd/tps65090.c       |  312 ++++++++++++++----------------------------
>  include/linux/mfd/tps65090.h |   73 ++++++++---
>  2 files changed, 159 insertions(+), 226 deletions(-)
All 5 patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
