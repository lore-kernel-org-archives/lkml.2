Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab1HIEmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 00:42:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:37042 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1HIEmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 00:42:37 -0400
Subject: Re: linux-next: manual merge of the moduleh tree with the
 slave-dma tree
From: Vinod Koul <vkoul@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Dan <dan.j.williams@intel.com>
Cc: vinod.koul@intel.com, Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110809125623.e25f685fd20c787fcf58fcfc@canb.auug.org.au>
References: <20110809125623.e25f685fd20c787fcf58fcfc@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 10:11:33 +0530
Message-ID: <1312864893.1539.48.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 12:56 +1000, Stephen Rothwell wrote:
> 
> Vinod, that slave-dma tree patch should probably remove the bare "struct
> scallerlist;" since it now includes scatterlist,h.
> 
Yes, makes sense Dan does this look good to you

From: Vinod Koul <vinod.koul@intel.com>
Date: Tue, 9 Aug 2011 10:08:10 +0530
Subject: [PATCH] dmaengine: remove struct scatterlist for header

Commit 90b44f8 introduces dmaengine_prep_slave_single API which adds
scatterlist.h in dmaengine.h, so defining struct scatterlist is not
required

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 include/linux/dmaengine.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 0d738c9..ace51af 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -26,8 +26,6 @@
 #include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
 
-struct scatterlist;
-
 /**
  * typedef dma_cookie_t - an opaque DMA cookie
  *
-- 
1.7.0.4




