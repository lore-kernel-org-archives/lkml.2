Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2IRGkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:40:09 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39281 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab2IRGkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:40:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAN1soZzFmRxWUh9Og31O8XoXKwPcNPszCseJDkt_6oNPx7gD-g@mail.gmail.com>
References: <CAPgLHd93SqsiFmE7y356VwBJtaac0APE__vk+8dBZnaOyt4org@mail.gmail.com>
 <CACRpkdYAeChEqeLrz0hQxpXrWp477iXoko01swG8Y=SA7tNh5Q@mail.gmail.com>
 <CAMPhdO_XJ2+=yrkLXVFTR4ykf8QnON7mBXQ2+2xiTor=wY5S+w@mail.gmail.com> <CAN1soZzFmRxWUh9Og31O8XoXKwPcNPszCseJDkt_6oNPx7gD-g@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 18 Sep 2012 14:39:45 +0800
Message-ID: <CAMPhdO9xKL48=0FRPrLZ=JP8epF5D=Ta0qheLEMQaL-eoe305w@mail.gmail.com>
Subject: Re: [PATCH] gpio: pxa: using for_each_set_bit to simplify the code
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Wei Yongjun <weiyj.lk@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 1:56 PM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:
> On Tue, Sep 18, 2012 at 1:43 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
>> On Mon, Sep 17, 2012 at 6:56 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> On Fri, Sep 14, 2012 at 4:36 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>>>
>>>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>>>
>>>> Using for_each_set_bit() to simplify the code.
>>>>
>>>> spatch with a semantic match is used to found this.
>>>> (http://coccinelle.lip6.fr/)
>>>>
>>>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>>
>>> PXA maintainers: does this look OK?
>>
>> I seem to have Acked this already in another mail, if that got lost, here
>> it is:
>>
>> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>>
> The another mail thread is for irq, not gpio. I'll apply it today. :)

Thanks Haojian!
