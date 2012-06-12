Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2FLIDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:03:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53351 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2FLIDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:03:22 -0400
Message-ID: <4FD6F7C6.80002@linaro.org>
Date: Tue, 12 Jun 2012 09:03:18 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca
Subject: Re: [PATCH 14/14] ARM: ux500: Move rtc-pl031 registration to Device
 Tree when enabled
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-15-git-send-email-lee.jones@linaro.org> <CACRpkdbJdA8rgcXX4Xc3sMrx==5jd-Scu1Xy0UKz0ot3_bbNzw@mail.gmail.com>
In-Reply-To: <CACRpkdbJdA8rgcXX4Xc3sMrx==5jd-Scu1Xy0UKz0ot3_bbNzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/12 22:43, Linus Walleij wrote:
> On Mon, Jun 11, 2012 at 5:25 PM, Lee Jones<lee.jones@linaro.org>  wrote:
>
>> During a Device Tree boot, all probing will now be completed on parse
>> of the Device Tree binary. In the same patch we remove platform
>> registration of the Real Time Clock.
>>
>> Signed-off-by: Lee Jones<lee.jones@linaro.org>
>
> Oh this is a bug fix really, well it's in the device tree so nevermind.

It is? How so?

> Acked-by: Linus Walleij<linus.walleij@linaro.org>
>
> Yours,
> Linus Walleij


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
