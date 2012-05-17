Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069Ab2EQPjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:39:24 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51071 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761981Ab2EQPjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205122117340.11826@axis700.grange>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-4-git-send-email-thomas.abraham@linaro.org>
	<Pine.LNX.4.64.1205040047280.18111@axis700.grange>
	<CAJuYYwQj7gzZ9piJAJLcf7SiyJnQ6nZ63-X9ieQ-FCj6TNhQPQ@mail.gmail.com>
	<Pine.LNX.4.64.1205122117340.11826@axis700.grange>
Date: Thu, 17 May 2012 21:09:21 +0530
Message-ID: <CAJuYYwTf=+Nkw2Ox9MYLybovSH8dNttYQzV4-Gg2xvZnVffZXw@mail.gmail.com>
Subject: Re: [PATCH 3/7] mmc: dw_mmc: add device tree support
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 May 2012 01:01, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Sure. I think, my patch, that I mentioned above, shall be dropped, at
> least in its present form. But if at least in principle we do want to have
> a common MMC OF parser for common bindings, some code from your patch
> would become redundant, I think. BTW, isn't this
>
> +       gpio = of_get_named_gpio(np, "wp_gpios", 0);
>
> a typo? Shouldn't it be "wp-gpios" instead?

Yes, it is a typo. Thanks for your review. This is fixed now.

Regards,
Thomas.
