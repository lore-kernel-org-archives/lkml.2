Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2KQXFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 18:05:13 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49543 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab2KQXFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 18:05:10 -0500
MIME-Version: 1.0
In-Reply-To: <1353020646-14867-1-git-send-email-ldewangan@nvidia.com>
References: <1353020646-14867-1-git-send-email-ldewangan@nvidia.com>
Date: Sun, 18 Nov 2012 00:05:08 +0100
Message-ID: <CACRpkdZ9tkd8U-sQH4ysdZvLAROH25oXmBMJe2hU6g71pe5YsQ@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND] gpio: tegra: read output value when gpio is set
 in direction_out
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 12:04 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Read the output value when gpio is set for the output mode for
> gpio_get_value(). Reading input value in direction out does not
> give correct value.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes from V1:
> - Keep the if part implementation same the else part to have implementation
>   same kind.
>
> Not too old patchi but just resending in case of it is missed.
> Adding acked by Stephen as he acked this patch.

This patch was already applied in my tree... sorry
no clue why you haven't seen it?

Yours,
Linus Walleij
