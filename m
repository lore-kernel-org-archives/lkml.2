Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2DPPkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:40:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:36869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab2DPPkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:40:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="154201596"
Date: Mon, 16 Apr 2012 17:49:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] mfd: rc5t583: add rc5t583's gpio in mfd device
 list
Message-ID: <20120416154901.GJ24130@sortiz-mobl>
References: <1333959955-968-1-git-send-email-ldewangan@nvidia.com>
 <1333959955-968-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333959955-968-3-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laxman,

On Mon, Apr 09, 2012 at 01:55:55PM +0530, Laxman Dewangan wrote:
> Adding the gpio of RC583 in the list of rc583 mfd devices
> to register the gpio driver of RC5T583.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/mfd/rc5t583.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
Applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
