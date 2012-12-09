Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab2LIPYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:24:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:19709 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758302Ab2LIPYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:24:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,246,1355126400"; 
   d="scan'208";a="178571825"
Date: Sun, 9 Dec 2012 16:24:48 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: arizona: Log if we fail to create the primary IRQ
 domain
Message-ID: <20121209152448.GC26699@sortiz-mobl>
References: <1354675586-24864-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354675586-24864-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Dec 05, 2012 at 11:46:26AM +0900, Mark Brown wrote:
> This is the only thing in probe for which we don't log an error.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-irq.c |    1 +
>  1 file changed, 1 insertion(+)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
