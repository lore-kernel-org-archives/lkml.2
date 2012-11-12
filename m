Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2KLQOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:14:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33221 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab2KLQOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:14:46 -0500
Message-ID: <50A12073.2010303@wwwdotorg.org>
Date: Mon, 12 Nov 2012 09:14:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: tegra: Make PINCTRL_TEGRA select PINMUX
 && PINCONF
References: <1352600482.23129.1.camel@phoenix>
In-Reply-To: <1352600482.23129.1.camel@phoenix>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2012 07:21 PM, Axel Lin wrote:
> Then we can remove "select PINMUX && PINCONF" from PINCTRL_TEGRA{20,30}.
> This simplifies the dependency.

> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig

>  config PINCTRL_TEGRA
> +	select PINMUX
> +	select PINCONF
>  	bool

With the same ordering comment as Shawn gave,

Acked-by: Stephen Warren <swarren@nvidia.com>
