Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab1LOFPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:15:04 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:12269 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1LOFPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:15:02 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 15 Dec 2011 13:23:26 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/9] irq: check domain hwirq range for DT translate
Message-ID: <20111215052314.GA21815@S2101-09.ap.freescale.net>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
 <1323876538-20406-3-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323876538-20406-3-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 09:28:51AM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> A DT node may have more than 1 domain associated with it, so make sure
> the hwirq number is within range when doing DT translation.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---

Acked-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn

