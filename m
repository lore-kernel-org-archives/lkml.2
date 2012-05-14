Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2ENI3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:29:15 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:25707
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab2ENI3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:29:13 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 14 May 2012 16:48:11 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Richard Zhao <richard.zhao@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <paul.liu@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>, <sameo@linux.intel.com>,
        <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/2] mfd: anatop: permit adata be NULL when access
 register
Message-ID: <20120514084810.GD20367@S2100-06.ap.freescale.net>
References: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com>
 <1336870794-6351-2-git-send-email-richard.zhao@freescale.com>
 <20120514035137.GB20367@S2100-06.ap.freescale.net>
 <20120514080835.GB31985@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120514080835.GB31985@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 09:08:36AM +0100, Mark Brown wrote:
> On Mon, May 14, 2012 at 11:51:38AM +0800, Shawn Guo wrote:
> 
> > From what I see, it's reasonable.  Then the immediate question I have
> > is, should we remove "struct anatop *adata" from anatop_read_reg and
> > anatop_write_reg completely?
> 
> Given the way these things tend to go it's probably guaranteeing that
> your next round of SoCs will have two register compatible anatop blocks :)

Considering anatop block tends to be a container of misc hardware
control bits, I haven't really seen any possibility that the future
SoCs will have multiple anatop blocks.

-- 
Regards,
Shawn

