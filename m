Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab2BWPdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 10:33:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:12196 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003Ab2BWPdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 10:33:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="114034506"
Date: Thu, 23 Feb 2012 16:32:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: s5m-core: Fix val_len parameters for
 regmap_raw_write
Message-ID: <20120223153258.GD24377@sortiz-mobl>
References: <1329188887.3132.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329188887.3132.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Feb 14, 2012 at 11:08:07AM +0800, Axel Lin wrote:
> The val_len parameters for regmap_raw_write should be "count * sizeof(u8)"
> (or simply "count") instead of "count * sizeof(u16)".
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
