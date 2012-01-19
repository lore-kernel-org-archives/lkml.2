Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2ASIVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:21:41 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:58318
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754427Ab2ASIVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:21:39 -0500
X-SpamScore: 0
X-BigFish: VS0(zz146fKzz1202h1082kzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4F17D2ED.6090502@freescale.com>
Date: Thu, 19 Jan 2012 16:23:09 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH resent v2 1/2] ioport : add DEFINE_RES_DMA_SIZE_NAMED
 macro
References: <1326959620-25920-1-git-send-email-b32955@freescale.com> <1326959620-25920-2-git-send-email-b32955@freescale.com> <20120119081427.GF2247@S2101-09.ap.freescale.net>
In-Reply-To: <20120119081427.GF2247@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn:
> I'm not sure the patch is welcomed.  You may want to just use
> DEFINE_RES_NAMED for such cases.
I ever wanted to use DEFINE_RES_NAMED.
But it seems i have to change some other 
code(/arch/arm/plat-samsung/devs.c).

Anyway, if someone do not like this macro. I can change it too.

Best Regards
Huang Shijie


