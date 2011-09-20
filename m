Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab1ITIbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 04:31:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:12064 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab1ITIbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 04:31:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,410,1312182000"; 
   d="scan'208";a="50784181"
Date: Tue, 20 Sep 2011 10:34:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: jz4740-adc: Make jz4740_adc_driver static
Message-ID: <20110920083415.GT32263@sortiz-mobl>
References: <1316441949-2277-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316441949-2277-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Mon, Sep 19, 2011 at 04:19:09PM +0200, Lars-Peter Clausen wrote:
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/mfd/jz4740-adc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
Thanks, applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
