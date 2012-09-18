Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab2IRFoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:44:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32776 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2IRFoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:44:11 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYAeChEqeLrz0hQxpXrWp477iXoko01swG8Y=SA7tNh5Q@mail.gmail.com>
References: <CAPgLHd93SqsiFmE7y356VwBJtaac0APE__vk+8dBZnaOyt4org@mail.gmail.com>
 <CACRpkdYAeChEqeLrz0hQxpXrWp477iXoko01swG8Y=SA7tNh5Q@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 18 Sep 2012 13:43:50 +0800
Message-ID: <CAMPhdO_XJ2+=yrkLXVFTR4ykf8QnON7mBXQ2+2xiTor=wY5S+w@mail.gmail.com>
Subject: Re: [PATCH] gpio: pxa: using for_each_set_bit to simplify the code
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 6:56 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Sep 14, 2012 at 4:36 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Using for_each_set_bit() to simplify the code.
>>
>> spatch with a semantic match is used to found this.
>> (http://coccinelle.lip6.fr/)
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> PXA maintainers: does this look OK?

I seem to have Acked this already in another mail, if that got lost, here
it is:

Acked-by: Eric Miao <eric.y.miao@gmail.com>

>
> Yours,
> Linus Walleij
