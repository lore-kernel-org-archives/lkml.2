Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab1GKVjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:39:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42685 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1GKVjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:39:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAKnu2MqzSm8BVK4z9E-ud8e_jUohDfSfYO9aW-oN3RFw4p7GrA@mail.gmail.com>
References: <1310310203-12288-1-git-send-email-sundaram@ti.com>
	<CAKnu2MqzSm8BVK4z9E-ud8e_jUohDfSfYO9aW-oN3RFw4p7GrA@mail.gmail.com>
Date: Mon, 11 Jul 2011 14:39:17 -0700
X-Google-Sender-Auth: noeTuS2ERI1TsCoh1C2Cogj4O3o
Message-ID: <CAA9_cmeWUjiTghKbjAvith5c6z9PDVdFSeK55RYWfyQKFSjA+Q@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride configuration
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sundaram Raju <sundaram@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 2:28 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> 2011/7/10 Sundaram Raju <sundaram@ti.com>:
>
>> Added new dma_ctrl_cmd TI_DMA_STRIDE_CONFIG to pass the TI DMA
>> controller specific configurations on how a buffer must be walked
>> through and how data is picked for transfer based on a specified
>> pattern over the channel.
>>
>> The configuration passed is specific to the TI DMA controller used.

...and I suspect the slave device drivers that use TI DMA are not
expected to ever work with other dmaengines?  Likely the case, but
just wondering out loud.

>> Signed-off-by: Sundaram Raju <sundaram@ti.com>
>
> This is exactly how I think we should do this.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
