Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2LJOqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:46:10 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58165 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab2LJOqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:46:08 -0500
MIME-Version: 1.0
In-Reply-To: <1355139464-6855-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355139464-6855-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1355139464-6855-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 10 Dec 2012 20:16:07 +0530
Message-ID: <CAKohpo=GRCQ8WUB1P2Xa5jZ5yWA-+8FTHra8q27y7Ov=ZroUuA@mail.gmail.com>
Subject: Re: [PATCH 2/2] dmatest: check for dma mapping error
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2012 17:07, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> We get a warning if CONFIG_DMA_API_DEBUG=y
>
> [   28.150631] WARNING: at lib/dma-debug.c:933 check_unmap+0x5d6/0x6ac()
> [   28.157058] dw_dmac dw_dmac.0: DMA-API: device driver failed to check map error[device address=0x0000000035698305] [size=14365 bytes] [mapped as single]
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
