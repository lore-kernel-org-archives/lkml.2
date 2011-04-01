Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1DALuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:50:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:31240 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab1DALut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:50:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,282,1299484800"; 
   d="scan'208";a="674138153"
Subject: Re: [PATCH] intel_mid_dma: fix runtime pm issues
From: "Koul, Vinod" <vinod.koul@intel.com>
To: kristen@linux.intel.com
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        Dan <dan.j.williams@intel.com>
In-Reply-To: <1301594563-19171-1-git-send-email-kristen@linux.intel.com>
References: <1301594563-19171-1-git-send-email-kristen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 16:51:00 +0530
Message-ID: <1301656860.18522.20.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 11:02 -0700, kristen@linux.intel.com wrote:
> From: Kristen Carlson Accardi <kristen@linux.intel.com>
> 
> Use the correct api in probe to enable runtime pm for this driver.
> Additionally, do not just call legacy suspend for runtime_suspend,
> as this duplicates some work the pci core does for you.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  drivers/dma/intel_mid_dma.c |   17 +++++++++++++----
>  1 files changed, 13 insertions(+), 4 deletions(-)
> 
Applied, Thanks

-- 
~Vinod

