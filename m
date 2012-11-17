Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2KQUOn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 15:14:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65240 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2KQUOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 15:14:42 -0500
MIME-Version: 1.0
In-Reply-To: <1352441060-31559-1-git-send-email-ldewangan@nvidia.com>
References: <1352441060-31559-1-git-send-email-ldewangan@nvidia.com>
Date: Sat, 17 Nov 2012 21:14:41 +0100
Message-ID: <CACRpkdaghDSZbPba5rjJFwsx8JbYarA_08BL-Of+ez_9fGPjaQ@mail.gmail.com>
Subject: Re: [PATCH V2] gpio: tegra: read output value when gpio is set in direction_out
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 7:04 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Read the output value when gpio is set for the output mode for
> gpio_get_value(). Reading input value in direction out does not
> give correct value.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Applied v2 with Stephen's ACK.

Yours,
Linus Walleij
