Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab2ISQCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:02:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:3703 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab2ISQCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:02:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="207959322"
Date: Wed, 19 Sep 2012 18:02:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: rc5t583: Fix warning messages
Message-ID: <20120919160237.GL28670@sortiz-mobl>
References: <1345704676-25778-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345704676-25778-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venu,

On Thu, Aug 23, 2012 at 12:21:16PM +0530, Venu Byravarasu wrote:
> Two variables named master_int and sleepseq_val, were just
> declared without initialization. Pointers to these variables
> were passed to mfd read function. After that these variables
> were used for some of the logical operations.
> 
> Though logically there is nothing wrong, compiler is complaining
> that the variables may be used uninitialized.
> 
> Hence fixing these warning messages by initializing them.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>  drivers/mfd/rc5t583-irq.c |    2 +-
>  drivers/mfd/rc5t583.c     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
