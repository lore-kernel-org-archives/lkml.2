Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab1LNPl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:41:57 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59820 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487Ab1LNPlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:41:53 -0500
Message-ID: <4EE8C3BC.8080808@gmail.com>
Date: Wed, 14 Dec 2011 09:41:48 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
CC: Grant Likely <grant.likely@secretlab.ca>, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH 0/9] irq domain for gen irq chip and pl061 DT irq support
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 09:28 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This series adds irq_domain support to generic irq chip, converts the
> pl061 gpio driver to use generic irq chip, and finally adds DT irq binding
> support for pl061. The pl061 driver is also fixed to use 0 for no irq
> instead of -1 or NO_IRQ.
> 
> The irq_domain support should be transparent to users of generic irq
> chip. Shawn Guo has tested previous version with i.MX AVIC and his fixes
> have been incorporated. Any testing by other users of generic irq chip
> is appreciated.
> 
> This series is also dependent on:
> 
> irqdomain: export irq_domain_simple_ops for !CONFIG_OF
> http://www.spinics.net/lists/arm-kernel/msg150290.html
> 
> gpio: pl061: drop extra check for NULL platform_data
> http://www.spinics.net/lists/arm-kernel/msg151701.html
> 
> Tested on highbank and built all defconfigs.
> 
> Rob

Forgot to mention this series is also available here:

git://sources.calxeda.com/kernel/linux.git pl061-domain

Rob
