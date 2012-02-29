Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2B2IWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:22:55 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:15618 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751299Ab2B2IWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:22:53 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz936eK1432N98dKzz1202h1082kzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F4DE0E5.8070808@freescale.com>
Date: Wed, 29 Feb 2012 16:25:09 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>, "cjb@laptop.org" <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/2] patch set about the MXS-DMA
References: <1329373053-19494-1-git-send-email-b32955@freescale.com>	 <4F4D9725.3090100@freescale.com> <1330502098.3545.78.camel@sauron.fi.intel.com>
In-Reply-To: <1330502098.3545.78.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem:
> On Wed, 2012-02-29 at 11:10 +0800, Huang Shijie wrote:
>> Hi:
>>
>> ping.
> Is this patch-set independent or requires something like gpma patches?
>
This patch set is independent, and it does not depend upon any other 
patches.

I will sent out the new GPMI patches (with DT enable) after this 
patch-set is merged.

thanks

BR
Huang Shijie

