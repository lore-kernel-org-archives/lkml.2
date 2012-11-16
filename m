Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab2KPJMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:12:36 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:59665 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2KPJMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:12:34 -0500
MIME-Version: 1.0
X-Originating-IP: [111.255.121.16]
In-Reply-To: <50A0C3C8.2020501@gmail.com>
References: <1352641495.3113.1.camel@phoenix>
	<50A0C3C8.2020501@gmail.com>
Date: Fri, 16 Nov 2012 17:12:33 +0800
Message-ID: <CAFRkauABcnqJSqewueY4rzVbm7uAqkZKitkR9ZmYjF0LhR26-Q@mail.gmail.com>
Subject: Re: [PATCH RFT 1/2] pinctrl: dove: Fix dove_audio1_ctrl_set when
 BIT(0|1|2|3) of config is clear
From: Axel Lin <axel.lin@ingics.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/12 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>:
> On 11/11/2012 02:44 PM, Axel Lin wrote:
>>
>> Current implementation in dove_audio1_ctrl_set() does not clear
>> corresponding
>> register bit if BIT(0|1|2|3) of config is clear. Fix it.
>>
>> Signed-off-by: Axel Lin<axel.lin@ingics.com>
>
>
> Axel,
>
> thanks for the hint on not clearing the audio1 bits before setting them.
> I will test this tonight and guess you should prepare a real patch for
> this one.

Hi Sebastian,
Does this patch work for you?
May I have your Acked-and-Tested-by if you think this patch is ok.

Thanks,
Axel
