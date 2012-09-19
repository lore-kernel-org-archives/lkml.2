Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2ISL2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:28:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:61620 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab2ISL2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:28:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="194793602"
Date: Wed, 19 Sep 2012 13:28:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andreas Pretzsch <apr@cn-eng.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Use devm_* APIs for mc13xxx: remove leftover kfree
Message-ID: <20120919112805.GH8138@sortiz-mobl>
References: <1347898641-17575-1-git-send-email-apr@cn-eng.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347898641-17575-1-git-send-email-apr@cn-eng.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Mon, Sep 17, 2012 at 06:17:21PM +0200, Andreas Pretzsch wrote:
> commit e7c706b1e5ccf28eaaf76c7a4613e80b0ca52863 migrated the allocation
> of struct mc13xxx to devm_* functions, but left a kfree(mc13xxx) in the
> mc13xxx_common_init error path. Remove it to prevent memory corruption.
> 
> Signed-off-by: Andreas Pretzsch <apr@cn-eng.de>
> ---
>  drivers/mfd/mc13xxx-core.c |    1 -
>  1 file changed, 1 deletion(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
