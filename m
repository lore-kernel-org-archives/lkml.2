Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2JRGE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:04:29 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:43244 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748Ab2JRGE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:04:28 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
Date: Thu, 18 Oct 2012 14:29:19 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 7/7] gpio/tegra: convert to use linear irqdomain
Message-ID: <20121018062917.GA32628@S2100-06.ap.freescale.net>
References: <1350415413-3723-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1350415413-3723-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 09:23:33PM +0200, Linus Walleij wrote:
> The MXS driver tries to do the work of irq_domain_add_linear()

s/MXS/tegra

> by reserving a bunch of descriptors somewhere and keeping track
> of the base offset, then calling irq_domain_add_legacy(). Let's
> stop doing that and simply use the linear IRQ domain.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpio-tegra.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

