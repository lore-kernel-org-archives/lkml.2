Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2FLOo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:44:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60351 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2FLOo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:44:56 -0400
Message-ID: <4FD755E3.5080504@linaro.org>
Date: Tue, 12 Jun 2012 15:44:51 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca
Subject: Re: [PATCH 14/14] ARM: ux500: Move rtc-pl031 registration to Device
 Tree when enabled
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-15-git-send-email-lee.jones@linaro.org> <CACRpkdbJdA8rgcXX4Xc3sMrx==5jd-Scu1Xy0UKz0ot3_bbNzw@mail.gmail.com> <4FD6F7C6.80002@linaro.org> <CACRpkdYiZkRT-XLbEBRzCBKJ+721OBVKmUF+v17seFiWxmndnw@mail.gmail.com>
In-Reply-To: <CACRpkdYiZkRT-XLbEBRzCBKJ+721OBVKmUF+v17seFiWxmndnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/12 15:32, Linus Walleij wrote:
> On Tue, Jun 12, 2012 at 10:03 AM, Lee Jones<lee.jones@linaro.org>  wrote:
>> On 11/06/12 22:43, Linus Walleij wrote:
>
>>> Oh this is a bug fix really, well it's in the device tree so nevermind.
>>
>> It is? How so?
>
> That the device tree was declaring a compatible node for something
> that never existed (stericsson,db8500-rtc) while the real node is
> "arm,rtc-pl031", "arm,primecell".
>
> Without this fix 3.4 will not have an PL031 RTC I guess?

Think of the old entry as a dummy one, a stub if you will. Quite a few 
of the entries were initially loaded into the Device Tree as a best 
effort first attempt and had to be changed at a later date. This is no 
different. I see this as an enablement patch rather than a bug-fix. In 
fact, there would have been a bug if this worked when it was initially 
written, as the driver would have probed twice on a DT boot. Once by DT 
and once by platform code.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
