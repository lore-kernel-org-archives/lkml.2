Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab2ADQUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:20:35 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:10806 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab2ADQUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:20:32 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F047C43.3060003@freescale.com>
Date: Wed, 4 Jan 2012 14:20:19 -0200
From: Fabio Estevam <fabio.estevam@freescale.com>
Organization: Freescale Semiconductor
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.20) Gecko/20110804 Thunderbird/3.1.12
MIME-Version: 1.0
To: <a.zummo@towertech.it>
CC: <rtc-linux@googlegroups.com>, Wolfram Sang <w.sang@pengutronix.de>,
        <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] rtc: Kconfig: Place RTC_DRV_IMXDI and RTC_MXC
 under "on-CPU RTC drivers"
References: <1323548042-25432-1-git-send-email-festevam@gmail.com> <1323693187-3466-1-git-send-email-fabio.estevam@freescale.com> <20111212124841.GF3485@pengutronix.de>
In-Reply-To: <20111212124841.GF3485@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 10:48 AM, Wolfram Sang wrote:
> On Mon, Dec 12, 2011 at 10:33:06AM -0200, Fabio Estevam wrote:
>> RTC_DRV_IMXDI and RTC_MXC are on-chip RTC modules, so move them under 
>> "on-CPU RTC drivers" selection menu.
>>
>> While at it change the dependency of RTC_DRV_IMXDI from ARCH_MX25 to SOC_IMX25.
>>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> 

Alessandro, ping?


