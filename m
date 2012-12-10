Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2LJOwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:52:17 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:47208 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2LJOwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:52:16 -0500
MIME-Version: 1.0
In-Reply-To: <1355150404-6732-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355150404-6732-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1355150404-6732-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 10 Dec 2012 20:22:16 +0530
Message-ID: <CAKohpo=T=vvrw7HcHoRAf1Zjo+gARfUySuETmSQWBESXvKH_6g@mail.gmail.com>
Subject: Re: [PATCHv2 2/2] dw_dmac: check for mapping errors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2012 20:10, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Otherwise we get a warning in case of CONFIG_DMA_API_DEBUG=y
>
> [   45.775943] WARNING: at lib/dma-debug.c:933 check_unmap+0x5d6/0x6ac()
> [   45.782369] dw_dmac dw_dmac.0: DMA-API: device driver failed to check map error[device address=0x00000000356efcc0] [size=28 bytes] [mapped as single]
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
