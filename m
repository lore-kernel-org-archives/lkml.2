Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab1DZEed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 00:34:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:61916 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1DZEec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 00:34:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="683924719"
Subject: Re: [PATCH v2 1/5] dmaengine: at_hdmac: modify way to use
 interrupts
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1303493836.git.nicolas.ferre@atmel.com>
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>
	 <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1303493836.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 09:32:54 +0530
Message-ID: <1303790574.896.11.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 19:41 +0200, Nicolas Ferre wrote:
> Now we use Buffer Transfer Completed interrupts. If we
> want a chained buffer completed information, we setup the
> ATC_IEN bit in CTRLB register in the lli.
> This is done by set_desc_eol() function and used by
> memcpy/slave_sg functions.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/dma/at_hdmac.c      |    4 ++--
>  drivers/dma/at_hdmac_regs.h |   11 ++++++++---
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
>  
Looks like your forgot to run checkpatch
WARNING: line over 80 characters
#401: FILE: drivers/dma/at_hdmac_regs.h:106:
+#define MEM_IF			0		/* specify AHB interface 0 as memory interface */

WARNING: line over 80 characters
#402: FILE: drivers/dma/at_hdmac_regs.h:107:
+#define PER_IF			1		/* specify AHB interface 1 as peripheral interface
*/

WARNING: line over 80 characters
#689: FILE: drivers/dma/at_hdmac.c:899:
+			direction == DMA_TO_DEVICE ? "TO DEVICE" : "FROM DEVICE",

total: 0 errors, 3 warnings, 465 lines checked

While I am okay with 3rd one, you can easily reformat code for first two
and avoid these two warnings...

-- 
~Vinod

