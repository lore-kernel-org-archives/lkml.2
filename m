Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab1GKJ20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 05:28:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35977 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1GKJ2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:28:25 -0400
MIME-Version: 1.0
In-Reply-To: <1310310203-12288-1-git-send-email-sundaram@ti.com>
References: <y>
	<1310310203-12288-1-git-send-email-sundaram@ti.com>
Date: Mon, 11 Jul 2011 11:28:24 +0200
X-Google-Sender-Auth: HvRmrXiPEKEysRniKszwoPKNQiM
Message-ID: <CAKnu2MqzSm8BVK4z9E-ud8e_jUohDfSfYO9aW-oN3RFw4p7GrA@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Sundaram Raju <sundaram@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        dan.j.williams@intel.com, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/10 Sundaram Raju <sundaram@ti.com>:

> Added new dma_ctrl_cmd TI_DMA_STRIDE_CONFIG to pass the TI DMA
> controller specific configurations on how a buffer must be walked
> through and how data is picked for transfer based on a specified
> pattern over the channel.
>
> The configuration passed is specific to the TI DMA controller used.
>
> Signed-off-by: Sundaram Raju <sundaram@ti.com>

This is exactly how I think we should do this.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
