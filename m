Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab2HHNHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:07:55 -0400
Received: from smtp2-v.fe.bosch.de ([139.15.237.6]:48585 "EHLO
	smtp2-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab2HHNHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:07:54 -0400
Message-ID: <50226409.1060800@de.bosch.com>
Date: Wed, 8 Aug 2012 15:05:13 +0200
From: Dirk Behme <dirk.behme@de.bosch.com>
Organization: Robert Bosch Car Multimedia GmbH
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] ARM: imx: gpmi-nand depends on mxs-dma
References: <1344430493-5304-1-git-send-email-arnd@arndb.de> <1344430493-5304-7-git-send-email-arnd@arndb.de> <CAOMZO5CZ7mJd89cN_S0KBS74mc5qTzvrfRbmHVX3nmEakx19ow@mail.gmail.com>
In-Reply-To: <CAOMZO5CZ7mJd89cN_S0KBS74mc5qTzvrfRbmHVX3nmEakx19ow@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.217.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.08.2012 15:01, Fabio Estevam wrote:
> Hi Arnd,
> 
> On Wed, Aug 8, 2012 at 9:54 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> It is not currently possible to build the gpmi-nand driver without
>> also building the mxs-dma driver. Clarify this Kconfig and enable
>> both in the defconfig file so we can build it again with both enabled.
>>
>> drivers/built-in.o: In function `gpmi_dma_filter':
>> clk-fixed-factor.c:(.text+0xafc18): undefined reference to `mxs_dma_is_apbh'
>> make[1]: *** [vmlinux] Error 1
>> make: *** [sub-make] Error 2
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Shawn Guo <shawn.guo@linaro.org>
>> Cc: Sascha Hauer <kernel@pengutronix.de>
> 
> I have already sent a fix for this to the mtd list:
> https://patchwork.kernel.org/patch/1236551/

Yes. But it seems it's not handled there? I'm trying since ~2 weeks to 
get something like your patch applied to get the broken mainline fixed, 
but unfortunately without success so far.

Best regards

Dirk
