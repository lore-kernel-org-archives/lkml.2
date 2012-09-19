Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2ISL0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:26:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:12363 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab2ISL03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:26:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="194793245"
Date: Wed, 19 Sep 2012 13:26:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps65090: remove redundant check
Message-ID: <20120919112621.GF8138@sortiz-mobl>
References: <1347859847-23341-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347859847-23341-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venu,

On Mon, Sep 17, 2012 at 11:00:47AM +0530, Venu Byravarasu wrote:
> Remove redundant check in is_volatile_reg().
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>  drivers/mfd/tps65090.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
