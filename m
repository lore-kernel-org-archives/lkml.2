Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2IKKV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:21:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:37072 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab2IKKV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:21:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,402,1344236400"; 
   d="scan'208";a="201420641"
Date: Tue, 11 Sep 2012 12:21:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Remove unused variable
Message-ID: <20120911102106.GQ3647@sortiz-mobl>
References: <1347066059-11401-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347066059-11401-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sat, Sep 08, 2012 at 09:00:59AM +0800, Mark Brown wrote:
> Left over as bitrot from previous changes.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-irq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Thanks, applied now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
