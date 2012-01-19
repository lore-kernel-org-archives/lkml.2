Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab2ASI0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:26:31 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:34188
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754609Ab2ASI03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:26:29 -0500
X-SpamScore: -6
X-BigFish: VS-6(zz146fK1432Nzz1202h1082kzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F17D40F.3080803@freescale.com>
Date: Thu, 19 Jan 2012 16:27:59 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH resent v2 1/2] ioport : add DEFINE_RES_DMA_SIZE_NAMED
 macro
References: <1326959620-25920-1-git-send-email-b32955@freescale.com> <1326959620-25920-2-git-send-email-b32955@freescale.com> <20120119081427.GF2247@S2101-09.ap.freescale.net> <4F17D2ED.6090502@freescale.com>
In-Reply-To: <4F17D2ED.6090502@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Shawn:
>> I'm not sure the patch is welcomed.  You may want to just use
>> DEFINE_RES_NAMED for such cases.
> I ever wanted to use DEFINE_RES_NAMED.
sorry. I misunderstood your meaning.

I think it's better to add a new macro. use DEFINE_RES_NAMED is not proper.

Best Regards
Huang Shijie


> But it seems i have to change some other 
> code(/arch/arm/plat-samsung/devs.c).
>
> Anyway, if someone do not like this macro. I can change it too.
>
> Best Regards
> Huang Shijie
>


