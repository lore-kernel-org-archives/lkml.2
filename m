Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2GPWf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:35:26 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60789 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab2GPWfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:35:23 -0400
MIME-Version: 1.0
In-Reply-To: <1342421510-10638-7-git-send-email-ldewangan@nvidia.com>
References: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com>
	<1342421510-10638-7-git-send-email-ldewangan@nvidia.com>
Date: Tue, 17 Jul 2012 00:35:22 +0200
Message-ID: <CACRpkdYgGhDoUYmm881QeJoOQxjZ-4DEoZhHMLxhKcA3GeOftg@mail.gmail.com>
Subject: Re: [PATCH V2 6/6] mfd: tps6586x: remove gpio support from core driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 8:51 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> The GPIO functionality of device tps6586x is added through
> platform gpio driver and it can be register as the mfd sub
> device and hence removing the duplicates code which register
> the gpio functionality from core driver.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1->V2
> No changes in code, just patch become 6th of series as change in defconfig
> got added.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
