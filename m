Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab2LLHgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 02:36:16 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43785 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2LLHgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 02:36:15 -0500
MIME-Version: 1.0
In-Reply-To: <201211301156.08060.b.zolnierkie@samsung.com>
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
	<201210301021.42803.b.zolnierkie@samsung.com>
	<CAJe_ZhdOt+T65FdkE0SpQ37uGsS8SkFyJ9hHM3B_8S8f7GQAcQ@mail.gmail.com>
	<201211301156.08060.b.zolnierkie@samsung.com>
Date: Wed, 12 Dec 2012 13:06:14 +0530
Message-ID: <CABb+yY0FxsZyBy=scTF31+QMWgHzKf7bNz8vsPowtiMkve7igg@mail.gmail.com>
Subject: Re: [PATCH 4/4] DMA: PL330: add device tree property for DMA_MEMCPY capability
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>, kgene.kim@samsung.com,
        pawel.moll@arm.com, vinod.koul@intel.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
        dinguyen@altera.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 4:26 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:

> Thank you for explaining it.  Here is a patch implementing the idea:
>
> From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Subject: [PATCH] DMA: PL330: add peripherals map to the device tree
>
> Add device tree (DT) property ("peri-map") for storing indices
> of peripherals connected to DMAC and fix DT nodes of client
> drivers to use 'dma peripheral id' instead of 'dma request id'.
> Also instead of setting DMA_MEMCPY capability unconditionally in
> pl330_probe() do it only when "peri-map" DT property is present
> (idea from Jassi Brar).  It fixes the issue on ARM EXYNOS
> platforms using DT where pdma controller erroneously was used
> for DMA_MEMCPY operations instead of mdma one (it seems to work
> correctly but at the cost of worse performance).
>
Sorry, we need to change it as per new generic dma DT bindings
  http://git.infradead.org/users/vkoul/slave-dma.git/blob/refs/heads/next:/Documentation/devicetree/bindings/dma/dma.txt

Thanks.
