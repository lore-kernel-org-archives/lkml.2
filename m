Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2E2J11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:27:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35276 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2E2J10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:27:26 -0400
Message-ID: <4FC4967A.2040608@linaro.org>
Date: Tue, 29 May 2012 17:27:22 +0800
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: axel.lin@gmail.com, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: Remove config AB8500_I2C_CORE Kconfig entry
References: <1338272340.3127.1.camel@phoenix> <4FC47CEB.8090106@linaro.org> <CAF+7xWnriCRAuGzTusrtCkYTyUNPKVXE_f0kwysNJ3=AkuzvvA@mail.gmail.com> <4FC488E1.3080406@linaro.org> <20120529091556.GB18977@sortiz-mobl>
In-Reply-To: <20120529091556.GB18977@sortiz-mobl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

> On Tue, May 29, 2012 at 04:29:21PM +0800, Lee Jones wrote:
>> On 29/05/12 15:53, Axel Lin wrote:
>>> 2012/5/29 Lee Jones<lee.jones@linaro.org>:
>>>> On 29/05/12 14:19, Axel Lin wrote:
>>>>>
>>>>> config AB8500_I2C_CORE is not used after commit d28f1db
>>>>> "mfd: Remove confusing ab8500-i2c file and merge into ab8500-core".
>>>>> Thus remove it.
>>>>>
>>>>> Signed-off-by: Axel Lin<axel.lin@gmail.com>
>>>>
>>>>
>>>> I have this patch embedded into a patch-set I'm going to send to ARM-SoC for
>>>> inclusion into -rc1 this afternoon. Would you mind leaving this one?
>>>
>>> I don't mind.
>>> But AFAIK, commit d28f1db is in mfd tree.
>>> Any reason you want to send the patch to ARM-SoC instead of mfd tree.
>>
>> I don't actually have a preference as to which tree it goes into, so
>> long as it's sent to Mainline on or before -rc1.
> I sent a pull request to Linus yesterday, including this commit.

This is something different and wasn't part of the pull-request.

Kind regards,
Lee


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
