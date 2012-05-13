Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2EMHGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 03:06:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65074 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2EMHGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 03:06:10 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <201205121453.45242.arnd.bergmann@linaro.org>
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com>
	<alpine.LFD.2.02.1205101351380.21030@xanadu.home>
	<CAK5ve-L4rcAx-=n5u7G0AQzvUG3ir_jzF_ibaSf-EntXAzFUCw@mail.gmail.com>
	<201205121453.45242.arnd.bergmann@linaro.org>
Date: Sun, 13 May 2012 00:06:09 -0700
Message-ID: <CAOesGMgy4QkLuB10q19e67n_kQw4++gDYbWNELN-ASayVYkjbA@mail.gmail.com>
Subject: Re: [PATCH v9 00/19] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
From: Olof Johansson <olof@lixom.net>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Bryan Wu <bryan.wu@canonical.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, tim.gardner@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 12, 2012 at 7:53 AM, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
> On Friday 11 May 2012, Bryan Wu wrote:
>> OK, I rebased my patch back on 3.4.0-rc6, please find it here:
>> git://kernel.ubuntu.com/roc/linux-2.6/.git leds
>>
>> linux-next branch can be also found here:
>> git://kernel.ubuntu.com/roc/linux-2.6/.git leds-next
>>
>> Arnd, could you please help me to merge? if got any issue, please
>> point to me to fix.
>>
>
> Hi Bryan,
>
> I've merged it into a new next/leds branch. I got conflicts with the clps711x
> and at91 cleanups that are already in the next/cleanup branch but I think
> I resolved them all correctly.  It would be nice if you and/or the maintainers
> of those platforms could confirm that.

At the end of my pass of merging branches tonight, I tried building
all defconfigs on ARM and got several new build errors due to LED
changes. The ones that have hit it so far are:
* assabet_defconfig
* at91rm9200_defconfig
* ebsa100_defconfig
* footbridge_defconfig

Bryan, please sort these out as soon as possible. Should be easy to
reproduce to debug. Meanwhile I've dropped the leds branch from
arm-soc's for-next branch so that we can bring in an updated
(bisectable without breakage) branch from you.


Thanks.

-Olof
