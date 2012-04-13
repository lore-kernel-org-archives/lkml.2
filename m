Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2DMWdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:33:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61422 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab2DMWdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:33:35 -0400
MIME-Version: 1.0
In-Reply-To: <4F88A660.8040304@redfish-solutions.com>
References: <1334101538-19127-1-git-send-email-gurligebis@gentoo.org>
	<CACPM=kUwXocWWMQUKyakydeH72d7FHj-Rxw3bzqc0qDeyWP-yg@mail.gmail.com>
	<4F88A660.8040304@redfish-solutions.com>
Date: Sat, 14 Apr 2012 00:33:35 +0200
X-Google-Sender-Auth: tsl1vnPdLscjaSY3n37zvYqkN2o
Message-ID: <CACPM=kUWzzWQ-UVA-0A9X2CMc1D86oLRXiJqp3RmfbTMV6LXBg@mail.gmail.com>
Subject: Re: [PATCH] NET5501: Change active_low to 0 for LED driver.
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

14. apr. 2012 00.19 skrev Philip Prindeville
<philipp_subx@redfish-solutions.com>:
> On 4/13/12 3:17 PM, Bjarke Istrup Pedersen wrote:
>> 11. apr. 2012 01.45 skrev Bjarke Istrup Pedersen <gurligebis@gentoo.org>:
>>> It seems that there was an error with the active_low = 1 for the
>>> LED, since it should be set to 0 (meaning that active is high,
>>> since 0 is false, hence the confusion.
>>>
>>> The wiki article about it confuses it, since it contradicts
>>> itself, regarding what turns on the LED.
>>>
>>> I have tested 3.4-rc2 on my net5501 with this patch, and it
>>> makes the LED behave correctly, where "none" turns it off, and
>>> "default-on" turns it on, when echoed onto the trigger "file"
>>> in /sys/class/leds.
>>>
>>> Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
>>> ---
>>>  arch/x86/platform/geode/net5501.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/arch/x86/platform/geode/net5501.c b/arch/x86/platform/geode/net5501.c
>>> index 66d377e..646e3b5 100644
>>> --- a/arch/x86/platform/geode/net5501.c
>>> +++ b/arch/x86/platform/geode/net5501.c
>>> @@ -63,7 +63,7 @@ static struct gpio_led net5501_leds[] = {
>>>                .name = "net5501:1",
>>>                .gpio = 6,
>>>                .default_trigger = "default-on",
>>> -               .active_low = 1,
>>> +               .active_low = 0,
>>>        },
>>>  };
>>>
>>> --
>>> 1.7.8.5
>>>
>>
>> I have tried sending it to linux-geode, but the list seems to reject
>> mails from me for some reason.
>> Anyone able to forward it to the right people for inclusion in 3.4-rcX ?
>>
>> Thanks in advance,
>> Bjarke
>
> The linux-geode list is currently buggered and without an owner, as far as I know.
>
> -Philip

That would explain it :)

Do you have a chance to push it upstream, like your changes? (Not sure
who I should poke about it)

/Bjarke

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
