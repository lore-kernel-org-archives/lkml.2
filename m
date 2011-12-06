Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1LFGh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:37:58 -0500
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:57532 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753372Ab1LFGh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:37:56 -0500
X-Greylist: delayed 53177 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Dec 2011 01:37:56 EST
Date: Tue, 6 Dec 2011 07:34:16 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, robherring2@gmail.com,
        grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH v3 1/3] ARM: at91/aic: add irq domain and device tree
 support
Message-ID: <20111206063416.GI9192@game.jcrosoft.org>
References: <1322590066-430-1-git-send-email-nicolas.ferre@atmel.com>
 <1322754127-15206-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322754127-15206-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13276893176746388332
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -80
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedrudefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnegfrhhlucfvnfffucdlvddtmdenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredvnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucffohhmrghinheplhhkmhhlrdhorhhgne
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -80
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedrudefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnegfrhhlucfvnfffucdlvddtmdenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredvnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucffohhmrghinheplhhkmhhlrdhorhhgne
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:42 Thu 01 Dec     , Nicolas Ferre wrote:
> Add an irqdomain for the AIC interrupt controller.
> The device tree support is mapping the registers and
> is using the irq_domain_simple_ops to manage hwirq
> translation.
> The documentation is describing the meaning of the
> two cells required for using this "interrupt-controller"
> in a device tree node.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> This patch should go on top of Jamie's patch:
> "irqdomain: export irq_domain_simple_ops for !CONFIG_OF"
> https://lkml.org/lkml/2011/12/1/109
> 
> v3: - change number of cells to define an AIC interrupt (irq trigger type)
>     - change current .dtsi files to match specification
>     - use irq_domain_simple_ops (for DT mapping)
> 
> v2: - use of_irq_init() function for device tree probing
>     - add documentation
>     - use own simple struct irq_domain_ops
just one stuff missing the definition of the external irq

Best Regards,
J.
