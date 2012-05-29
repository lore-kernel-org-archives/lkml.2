Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2E2Phl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 11:37:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51242 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2E2Phk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 11:37:40 -0400
Message-ID: <4FC4ED3F.4050108@linaro.org>
Date: Tue, 29 May 2012 23:37:35 +0800
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: axel.lin@gmail.com, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: Remove config AB8500_I2C_CORE Kconfig entry
References: <1338272340.3127.1.camel@phoenix> <4FC47CEB.8090106@linaro.org> <CAF+7xWnriCRAuGzTusrtCkYTyUNPKVXE_f0kwysNJ3=AkuzvvA@mail.gmail.com> <4FC488E1.3080406@linaro.org> <20120529091556.GB18977@sortiz-mobl> <4FC4967A.2040608@linaro.org> <20120529105255.GC18977@sortiz-mobl> <4FC4E5EF.9080703@linaro.org> <20120529152728.GF18977@sortiz-mobl>
In-Reply-To: <20120529152728.GF18977@sortiz-mobl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/12 23:27, Samuel Ortiz wrote:
> Hi Lee,
>
> On Tue, May 29, 2012 at 11:06:23PM +0800, Lee Jones wrote:
>> On 29/05/12 18:52, Samuel Ortiz wrote:
>>> Hi Lee,
>>>
>>> On Tue, May 29, 2012 at 05:27:22PM +0800, Lee Jones wrote:
>>>> Hi Sam,
>>>>
>>>>> On Tue, May 29, 2012 at 04:29:21PM +0800, Lee Jones wrote:
>>>>>> On 29/05/12 15:53, Axel Lin wrote:
>>>>>>> 2012/5/29 Lee Jones<lee.jones@linaro.org>:
>>>>>>>> On 29/05/12 14:19, Axel Lin wrote:
>>>>>>>>>
>>>>>>>>> config AB8500_I2C_CORE is not used after commit d28f1db
>>>>>>>>> "mfd: Remove confusing ab8500-i2c file and merge into ab8500-core".
>>>>>>>>> Thus remove it.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Axel Lin<axel.lin@gmail.com>
>>>>>>>>
>>>>>>>>
>>>>>>>> I have this patch embedded into a patch-set I'm going to send to ARM-SoC for
>>>>>>>> inclusion into -rc1 this afternoon. Would you mind leaving this one?
>>>>>>>
>>>>>>> I don't mind.
>>>>>>> But AFAIK, commit d28f1db is in mfd tree.
>>>>>>> Any reason you want to send the patch to ARM-SoC instead of mfd tree.
>>>>>>
>>>>>> I don't actually have a preference as to which tree it goes into, so
>>>>>> long as it's sent to Mainline on or before -rc1.
>>>>> I sent a pull request to Linus yesterday, including this commit.
>>>>
>>>> This is something different and wasn't part of the pull-request.
>>> d28f1d was part of the pull request.
>>
>> Right. But this is not the same thing. The patch I (and Axel) wrote
>> removes remnant cruft from d28f1d. I didn't see that on moving
>> AB8500_I2C_CORE to AB8500_CORE I left a Kconfig entry behind which
>> is no longer used by anything. This patch removes that cruft.
> Yes, I saw the patch. I though you were saying that d28f1d was not part of the
> pull request and that you were going to push it through arm-soc.
> Anyway, I think the Kconfig cleanup patch should go through my tree unless you
> already sent it for arm-soc inclusion.

I haven't. I sent the entire patch-set to Arnd for first review today. 
After he's okay:ed it, I'll send it to the MLs sometime tomorrow. I will 
ensure you are CC'ed. I don't have any issues with the patch going 
through your tree.

Thanks Sam.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
