Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab2ATD17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 22:27:59 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:30213
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111Ab2ATD14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 22:27:56 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz1432Nzz1202h1082kzzz2dhc1bhc31hc1ah2a8h668h839h941h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F18DF95.80700@freescale.com>
Date: Fri, 20 Jan 2012 11:29:25 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <vinod.koul@intel.com>,
        <artem.bityutskiy@intel.com>, <shijie8@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <LW@KARO-electronics.de>,
        <alsa-devel@alsa-project.org>, <b29396@freescale.com>
Subject: Re: [PATCH 00/10] patch set about the MXS-DMA
References: <1326953767-24155-1-git-send-email-b32955@freescale.com> <20120119091034.GH2247@S2101-09.ap.freescale.net> <20120119094513.GB2630@pengutronix.de>
In-Reply-To: <20120119094513.GB2630@pengutronix.de>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> [2] patch 6 ~ patch 10: rewrite the last parameter of mxs_dma_prep_slave_sg().
>> For the sake of bitsec, at least patches #7 and #8 need to be one patch.
>> That said, if I apply the series and then check out the commit at patch
>> #7, you need to all mxs-dma client drivers, mxs-mmc, gpmi do not break.
> I'd say patch 6-10 should be squashed, simply. My personal preference is
> to change #9 to simply read the register when needed and do not expand
It's better to add a new field. i also want to add a new field
`bch_version`, because different
BCH version may support different ECC strength. For example, some
version BCH can support to 24 bit,
while the latest BCH may support to 40 bit. So the BCH version may
limits the computing of ECC strength.

Best Regards
Huang Shijie

> the struct, but this is a minor thing.
>
> Regards,
>
>    Wolfram
>


