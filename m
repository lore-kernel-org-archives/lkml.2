Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab2BAMaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 07:30:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41042 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab2BAMay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 07:30:54 -0500
MIME-Version: 1.0
In-Reply-To: <1328078344-11670-1-git-send-email-ldewangan@nvidia.com>
References: <1328078344-11670-1-git-send-email-ldewangan@nvidia.com>
Date: Wed, 1 Feb 2012 13:30:54 +0100
Message-ID: <CACRpkdbNxTe928p=7XdZVbqqfC5k0s1fqE=8DNa5zmg40pjwrQ@mail.gmail.com>
Subject: Re: [PATCH V2] gpio: tps65910: Add sleep control support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        gg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 7:39 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> The device tps65910/tps65911 supports the sleep
> functionality in some of gpios. If gpio is configured
> in output mode and sleep is enabled then during device
> sleep state, the output of gpio becomes LOW regardless
> of non-sleep output value.
> Such gpio can be used to control regulator switch such
> that output of regulator is off in device sleep state.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> Taken care of review comments from Linus Walleij's
> - Remove magic numbers and added macro for defining them.
> - Used bool type for the platform's gpio sleep control data.

Thanks, looks good!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
