Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335Ab2EIPi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:38:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:57144 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab2EIPiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:38:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140920511"
Date: Wed, 9 May 2012 17:48:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: Re: [PATCH] mfd: tps65090: Return proper error if regmap_init_i2c
 fails
Message-ID: <20120509154818.GN1794@sortiz-mobl>
References: <1335317436.24039.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335317436.24039.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Apr 25, 2012 at 09:30:36AM +0800, Axel Lin wrote:
> Return proper error instead of 0 if regmap_init_i2c fails.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/tps65090.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
