Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab2KMSzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:55:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:64399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab2KMSzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:55:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,768,1344236400"; 
   d="scan'208";a="219115079"
Date: Tue, 13 Nov 2012 19:55:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/6] MFD: twl6040: Conversion to use regmap_irq
Message-ID: <20121113185521.GN27828@sortiz-mobl>
References: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 01:55:27PM +0200, Peter Ujfalusi wrote:
> Hello,
> 
> This series will convert the twl6040 MFD core driver to use regmap_irq instead
> of the custom interrupt code it used. In this way considerable amount of code
> can be removed and we are going to use common, well tested code for the interrupt
> dispatch.
Looks great. I applied all 6 patches to my for-next branch, thanks.
Mark, thanks for the review.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
