Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423649Ab2KOLYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:24:55 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62650 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423250Ab2KOLYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:24:54 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYmYjb7-qs005Y3K6xrDSpe2Y57xeJiKD1GVzpp4km7jA@mail.gmail.com>
References: <1352702750.15066.4.camel@phoenix>
	<CACRpkdbMPokEH80WX+M8yvAWAM-XGend3cts4K0eaj=oke8rLQ@mail.gmail.com>
	<CAN1soZy=nQfqok9pzzg9LX+wStEdJ=eCvdWPG5WA32f6bDbb1Q@mail.gmail.com>
	<CACRpkdYmYjb7-qs005Y3K6xrDSpe2Y57xeJiKD1GVzpp4km7jA@mail.gmail.com>
Date: Thu, 15 Nov 2012 19:24:53 +0800
Message-ID: <CAN1soZxAGd4NMeONW5Xro6Y4jwnbF-mLQ5E4FkqoFdWeW_1JcQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pxa3xx: Use devm_request_and_ioremap
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 7:19 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Nov 14, 2012 at 2:47 AM, Haojian Zhuang
> <haojian.zhuang@gmail.com> wrote:
>> On Tue, Nov 13, 2012 at 10:33 PM, Linus Walleij
>> <linus.walleij@linaro.org> wrote:
>>> On Mon, Nov 12, 2012 at 7:45 AM, Axel Lin <axel.lin@ingics.com> wrote:
>>>
>>>> Use managed resources API to simplify the code.
>>>> Also ensure we do request mem_region before ioremap.
>>>>
>>>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>>>
>>> Obviously correct, patch applied.
>>>
>>> Yours,
>>> Linus Walleij
>>
>> If the patches on pinctrl-single driver are merged, it will be used as
>> pinctrl driver for PXA/MMP.
>> And this pinctrl-pxa3xx driver would be deleted. So it's not recommend
>> to update code on this
>> driver.
>
> I'll take care if it if there is a conflict, it will all be in the pinctrl
> tree anyway right?
>
> Yours,
> Linus Walleij

Thanks.
