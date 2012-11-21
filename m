Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2KULZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:25:46 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:57668 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab2KULZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:25:44 -0500
Message-ID: <50ACBA36.4030101@atmel.com>
Date: Wed, 21 Nov 2012 12:25:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-mmc@vger.kernel.org>,
        "Linux Kernel list" <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [GIT PULL v2] at91: fixes for 3.7-rc7
References: <50AA5ED5.8090901@atmel.com> <CAOesGMjAYtEkmEYnzCQ4G821BWG9D6LHvgt5aOMJgus_hzFkRA@mail.gmail.com> <50AA6C76.3000606@atmel.com> <50AB466F.5010500@atmel.com> <20121121070303.GD7615@quad.lixom.net>
In-Reply-To: <20121121070303.GD7615@quad.lixom.net>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 08:03 AM, Olof Johansson :
> Hi,
> 
> 
> On Tue, Nov 20, 2012 at 09:59:27AM +0100, Nicolas Ferre wrote:
>> Arnd, Olof,
>>
>> Just for the record, I do not want to put pressure at a such late time in
>> the 3.7-rc process. So, I just reworked that pull-request because the previous
>> one was wrong:
>> - wrong patch content (DT nodes with wrong size)
>> - not all tags in patches (Jean-Christophe and Arnd tags were missing...)
>>
>> Just to start from a sane base if I have to rebase this work for 3.8, I let you know
>> that I have updated this tag...
>>
>> The following changes since commit 641f3ce64b050961d454a0716bb6dbf528315aac:
>>
>>   ARM: at91/usbh: fix overcurrent gpio setup (2012-11-16 10:46:29 +0100)
>>
>> are available in the git repository at:
>>
>>   git://github.com/at91linux/linux-at91.git tags/at91-fixes
> 
> The new patches seem to belong in an at91/dt branch, not in a fixes one.
> 
> I can pull in the previous fixes branch as an at91/fixes-non-critical for 3.8
> if you want. There's no need to rebase them for this, is there? What is the
> pinctrl dependency that you are talking about, are some of these patches needed
> as prerequisites for pinctrl changes or the other way around?
> 
> Sorry if I've missed more elaborate emails on this and are asking repeat
> questions. ;)

No worries Olof, I might have been more precise in the subject of my
email: I have made up my mind and consider this material for 3.8.

As for the relation with pinctrl, we have made big modification to the
layout of some dtsi/dts there and it would make everyones' life easier
if we queue these dt/mmc changes on top of the current pinctrl tree...
Moreover, Jean-Christophe plans to add the pinctrl part of these
additions on top of the modification present in this pull-request: one
more reason to queue them in pinctrl git tree.

So, in brief: forget this pull-request (and the one that it replaces
obviously).

Thanks, bye,
-- 
Nicolas Ferre
