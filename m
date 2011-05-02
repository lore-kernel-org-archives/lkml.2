Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab1EBKqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 06:46:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:7896 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424Ab1EBKqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 06:46:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,302,1301900400"; 
   d="scan'208";a="686930382"
Subject: Re: [PATCH v3 1/5] dmaengine: at_hdmac: modify way to use
 interrupts
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <35f32b2bdf51d9d5867ca352ce96d786c74a58eb.1304174965.git.nicolas.ferre@atmel.com>
References: <1303791881.896.18.camel@vkoul-udesk3>
	 <35f32b2bdf51d9d5867ca352ce96d786c74a58eb.1304174965.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 15:44:04 +0530
Message-ID: <1304331244.1589.25.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-30 at 16:57 +0200, Nicolas Ferre wrote:
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
All, Applied, Thanks

-- 
~Vinod

