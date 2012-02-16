Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab2BPCZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:25:46 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:44104
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697Ab2BPCZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:25:42 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz1432Nzz1202h1082kzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F3C6996.8060205@freescale.com>
Date: Thu, 16 Feb 2012 10:27:34 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: <vinod.koul@intel.com>, <artem.bityutskiy@intel.com>,
        <w.sang@pengutronix.de>, <LW@KARO-electronics.de>,
        <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>, <cjb@laptop.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/2] mxs-dma : rewrite the last parameter of mxs_dma_prep_slave_sg()
References: <1329110756-14434-1-git-send-email-b32955@freescale.com> <1329110756-14434-3-git-send-email-b32955@freescale.com> <20120215195552.GB2399@r65073-Latitude-D630> <4F3C6466.9000500@freescale.com> <20120216021223.GF30946@r65073-Latitude-D630>
In-Reply-To: <20120216021223.GF30946@r65073-Latitude-D630>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
>> Hi Shawn:
>>> I'm trying to give it a test.  But it does not apply on either mainline
>>> or next tree.  You probably had a wrong base for this patch.
>>>
>> thanks for your work.
>>
>> As the previous email said, this patch set bases on :[PATCH v2]
>> mtd/gpmi : add gpmi support for mx6q.
>>
> Then you are doing something wrong.  This series should be based on
> mainline, and then you add imx6q support on top of this series.
sorry for the inconvenience.
I send the two patches at the same time.

The mtd/gpmi patch is just a small patch, I think it will be merged 
before this patch set.

BR
Huang Shijie



