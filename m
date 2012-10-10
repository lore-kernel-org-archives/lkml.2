Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2JJHtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 03:49:45 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59871 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2JJHte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 03:49:34 -0400
MIME-Version: 1.0
In-Reply-To: <1349712805-10014-4-git-send-email-ldewangan@nvidia.com>
References: <1349712805-10014-1-git-send-email-ldewangan@nvidia.com>
	<1349712805-10014-4-git-send-email-ldewangan@nvidia.com>
Date: Wed, 10 Oct 2012 09:49:33 +0200
Message-ID: <CACRpkdZTMqUV1gFhREcRjWgnKq3h6NySGJVZt3dzkXCLKroCxA@mail.gmail.com>
Subject: Re: [PATCH 3/3] mfd: tps6586x: implement gpio_to_irq
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 6:13 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> The TPS6586x adds the interrupt of this device using
> linear mapping on irq domain.
> Hence, implement gpio_to_irq to get the irq number
> corresponding to TPS6586x GPIOs which is created
> dynamically.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Looks good to me:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess you will funnel this through Sam's MFD tree?

Yours,
Linus Walleij
