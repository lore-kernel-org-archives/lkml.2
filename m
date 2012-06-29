Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2F2QIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:08:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:42396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab2F2QIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:08:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162289716"
Date: Fri, 29 Jun 2012 18:19:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: max77693: Staticise pm_ops
Message-ID: <20120629161947.GR22806@sortiz-mobl>
References: <1338909359-31380-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338909359-31380-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jun 05, 2012 at 04:15:59PM +0100, Mark Brown wrote:
> They're not referenced outside this file.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/max77693.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Thanks, applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
