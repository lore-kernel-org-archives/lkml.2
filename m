Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378Ab0HEQVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:21:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:22900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759094Ab0HEQVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:21:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,323,1278313200"; 
   d="scan'208";a="825045570"
Date: Thu, 5 Aug 2010 18:21:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] wm8350-core: fix wrong kfree in error path
Message-ID: <20100805162116.GB7722@sortiz-mobl>
References: <1280886861.31990.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280886861.31990.5.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Wed, Aug 04, 2010 at 09:54:21AM +0800, Axel Lin wrote:
> This patch includes below fixes:
> 1. fix wm8350_create_cache error path
>    make sure wm8350->reg_cache is freed in error path.
> 2. fix wm8350_device_init error path
>    no need to kfree(wm8350->reg_cache) in the case of goto out.
Applied, although as Mark pointed out, I'd have preferred 2 patches here.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
