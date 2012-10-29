Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2J2GGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:06:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:44419 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab2J2GGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:06:53 -0400
Subject: Re: [PATCH] dma: amba-pl08x: use vchan_dma_desc_free_list
From: Vinod Koul <vkoul@infradead.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Dan Williams <djbw@fb.com>
In-Reply-To: <1351352973-3719-2-git-send-email-akinobu.mita@gmail.com>
References: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
	 <1351352973-3719-2-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 11:23:44 +0530
Message-ID: <1351490024.7077.34.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-28 at 00:49 +0900, Akinobu Mita wrote:
> vchan_dma_desc_free_list() iterates through each virt_dma_desc in the
> specified list_head and calls vchan->desc_free().
> 
> We can use it instead of repeated execution of pl08x_desc_free() for
> each
> virt_dma_desc in the list_head.  Because vchan->desc_free callback is
> set
> as pl08x_desc_free() for amba-pl08x driver. 
Applied thanks
-- 
Vinod Koul
Intel Corp.

