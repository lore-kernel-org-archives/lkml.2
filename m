Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1JPILn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 04:11:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:1085 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab1JPILm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 04:11:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,353,1315206000"; 
   d="scan'208";a="27096962"
Subject: Re: [PATCH 07/10] spi, serial: move to dma_transfer_direction
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Alan Cox <alan@linux.intel.com>
In-Reply-To: <20111016042158.GB4901@ponder.secretlab.ca>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	 <1318570705-17595-8-git-send-email-vinod.koul@intel.com>
	 <20111016042158.GB4901@ponder.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Oct 2011 13:33:14 +0530
Message-ID: <1318752194.23438.47.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-15 at 22:21 -0600, Grant Likely wrote:
> On Fri, Oct 14, 2011 at 11:08:22AM +0530, Vinod Koul wrote:
> > From: Vinod Koul <vinod.koul@linux.intel.com>
> > 
> > Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Alan Cox <alan@linux.intel.com>
> 
> This looks okay to me.  What tree does it need to be merged through?
Can you pls send you formal ack

I plan to take this entire series thru slave-dma tree.

-- 
~Vinod

