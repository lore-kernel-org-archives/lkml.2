Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab2KPScI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:32:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49782 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2KPScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:32:06 -0500
Message-ID: <50A686A1.6000304@gmail.com>
Date: Fri, 16 Nov 2012 19:32:01 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 1/2] pinctrl: dove: Fix dove_audio1_ctrl_set when
 BIT(0|1|2|3) of config is clear
References: <1352641495.3113.1.camel@phoenix> <50A0C3C8.2020501@gmail.com> <CAFRkauABcnqJSqewueY4rzVbm7uAqkZKitkR9ZmYjF0LhR26-Q@mail.gmail.com>
In-Reply-To: <CAFRkauABcnqJSqewueY4rzVbm7uAqkZKitkR9ZmYjF0LhR26-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 10:12 AM, Axel Lin wrote:
> 2012/11/12 Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>:
>> On 11/11/2012 02:44 PM, Axel Lin wrote:
>>>
>>> Current implementation in dove_audio1_ctrl_set() does not clear
>>> corresponding
>>> register bit if BIT(0|1|2|3) of config is clear. Fix it.
>>>
>>> Signed-off-by: Axel Lin<axel.lin@ingics.com>
>>
>>
>> Axel,
>>
>> thanks for the hint on not clearing the audio1 bits before setting them.
>> I will test this tonight and guess you should prepare a real patch for
>> this one.
>
> Hi Sebastian,
> Does this patch work for you?
> May I have your Acked-and-Tested-by if you think this patch is ok.

Axel,

pinctrl for Dove will not be enabled before DT clock support for Dove,
which will hopefully make it into 3.8. If you agree, I will test and push it
with the related patches for enabling pinctrl.

Sebastian

