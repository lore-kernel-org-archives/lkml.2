Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab2JKOLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:11:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38229 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab2JKOLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:11:34 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "Hilman, Kevin" <khilman@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-keystone@list.ti.com - Linux developers for Keystone family of
	devices (May contain non-TIers)" <linux-keystone@list.ti.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 01/13] clk: davinci - add Main PLL clock driver
Thread-Topic: [PATCH 01/13] clk: davinci - add Main PLL clock driver
Thread-Index: AQHNp5wfJJvjOOrf7UiEit6UQh9q7Je0JG6g
Date: Thu, 11 Oct 2012 14:10:16 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041FDA2E@DFLE12.ent.ti.com>
References: <1348682889-9509-1-git-send-email-m-karicheri2@ti.com>
 <1348682889-9509-2-git-send-email-m-karicheri2@ti.com>
 <507563C3.2000305@ti.com> <5076A0DE.4070900@ti.com>
In-Reply-To: <5076A0DE.4070900@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9BEBeCp011271

>> -----Original Message-----
>> From: Nori, Sekhar
>> Sent: Thursday, October 11, 2012 6:35 AM
>> To: Nori, Sekhar
>> Cc: Karicheri, Muralidharan; Hilman, Kevin; davinci-linux-open-
>> source@linux.davincidsp.com; mturquette@linaro.org; linux-c6x-dev@linux-c6x.org;
>> arnd@arndb.de; linus.walleij@linaro.org; linux-kernel@vger.kernel.org;
>> rob.herring@calxeda.com; linux-keystone@list.ti.com - Linux developers for Keystone
>> family of devices (May contain non-TIers); viresh.linux@gmail.com;
>> linux@arm.linux.org.uk; akpm@linux-foundation.org; shawn.guo@linaro.org; linux-arm-
>> kernel@lists.infradead.org
>> Subject: Re: [PATCH 01/13] clk: davinci - add Main PLL clock driver
>> 
>> On 10/10/2012 5:32 PM, Sekhar Nori wrote:
>> > Hi Murali,
>> >
>> > On 9/26/2012 11:37 PM, Murali Karicheri wrote:
>> >> This is the driver for the main PLL clock hardware found on DM SoCs.
>> >> This driver borrowed code from arch/arm/mach-davinci/clock.c and
>> >> implemented the driver as per common clock provider API. The main PLL
>> >> hardware typically has a multiplier, a pre-divider and a post-divider.
>> >> Some of the SoCs has the divider fixed meaning they can not be
>> >> configured through a register. HAS_PREDIV and HAS_POSTDIV flags are
>> >> used to tell the driver if a hardware has these dividers present or not.
>> >> Driver is configured through the structure clk_davinci_pll_data that
>> >> has the platform data for the driver.
>> >>
>> >> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> >
>> > Are you using git-format-patch to generate the patches? It should have
>> > added a diffstat here by default which is very useful in quickly
>> > understanding what the patch is touching.
>> >>
>> >> diff --git a/drivers/clk/davinci/clk-davinci-pll.c
>> >> b/drivers/clk/davinci/clk-davinci-pll.c
>> 
>> Looking at how common clock framework for mxs has been implemented, this file should
>> simply be clk-pll.c. That makes sense as you are creating a davinci folder anyway. Similar
>> change required for psc as well.
>> 

Alternately, do we need  a davinci folder? Can't we just add it to the clk/ directory? These IPs are re-used in c6x and keystone architectures. So it make sense to keep in the clk folder. If agree, I can make this change in v3.

>> Thanks,
>> Sekhar
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
