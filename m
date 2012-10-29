Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2J2GEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:04:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:44394 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab2J2GEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:04:51 -0400
Subject: Re: [PATCH] ioat: Fix DMA memory sync direction correct flag
From: Vinod Koul <vkoul@infradead.org>
To: shuah.khan@hp.com
Cc: vinod.koul@intel.com, djbw@fb.com, rmk+kernel@arm.linux.org.uk,
        linus.walleij@linaro.org, jassisinghbrar@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        shuahkhan@gmail.com
In-Reply-To: <1351182152.2432.25.camel@lorien2>
References: <1351182152.2432.25.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 11:20:09 +0530
Message-ID: <1351489809.7077.32.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 10:22 -0600, Shuah Khan wrote:
> ioat does DMA memory sync with DMA_TO_DEVICE direction on a buffer allocated
> for DMA_FROM_DEVICE dma, resulting in the following warning from dma debug.
> Fixed the dma_sync_single_for_device() call to use the correct direction.
Applied, thanks

-- 
Vinod Koul
Intel Corp.

