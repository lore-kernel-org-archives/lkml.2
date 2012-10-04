Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2JDStW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:49:22 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:57157 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379Ab2JDStU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:49:20 -0400
Message-ID: <506DDA16.8070604@metafoo.de>
Date: Thu, 04 Oct 2012 20:48:54 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH] pwm: Get rid of HAVE_PWM
References: <1349330819-11924-1-git-send-email-thierry.reding@avionic-design.de> <506DA487.9070400@metafoo.de> <20121004182931.GA7228@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121004182931.GA7228@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 08:29 PM, Thierry Reding wrote:
> On Thu, Oct 04, 2012 at 05:00:23PM +0200, Lars-Peter Clausen wrote:
>> On 10/04/2012 08:06 AM, Thierry Reding wrote:
>>> [...]
>>> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
>>> index 331d574..b38f23d 100644
>>> --- a/arch/mips/Kconfig
>>> +++ b/arch/mips/Kconfig
>>> @@ -219,7 +219,8 @@ config MACH_JZ4740
>>>  	select GENERIC_GPIO
>>>  	select ARCH_REQUIRE_GPIOLIB
>>>  	select SYS_HAS_EARLY_PRINTK
>>> -	select HAVE_PWM
>>> +	select PWM
>>> +	select PWM_JZ4740
>>>  	select HAVE_CLK
>>>  	select GENERIC_IRQ_CHIP
>>
>> I'm not sure if this is such a good idea, not all jz4740 based board
>> necessarily require PWM.
> 
> This really only restores previous behaviour. But I agree that this is
> potentially not what we want. Maybe we should just not select this for
> any boards but rather leave it up to some default configuration. If so
> the patch can be made simpler by just removing the HAVE_PWM entries.

At least for JZ4740 I think that is the better solution.

Thanks,
- Lars

