Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1IAM2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:28:50 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59724 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab1IAM2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAEDdjHeDYFqq7gLMEnhwP8jfA-xqTpTGVOSN017avC1JmXrEpg@mail.gmail.com>
References: <CAEDdjHfu71X04JR2Yx8N495bDoJRudch3xbzNAEmUpVxYS+Oww@mail.gmail.com>
	<4E5F77A7.7090200@tuxonice.net>
	<CAEDdjHeDYFqq7gLMEnhwP8jfA-xqTpTGVOSN017avC1JmXrEpg@mail.gmail.com>
Date: Thu, 1 Sep 2011 13:28:48 +0100
Message-ID: <CAEDdjHcucDs7uyNzD1293bJNihQRS1UtOxxBYfSq9qHMLv3A0w@mail.gmail.com>
Subject: Re: [TuxOnIce-devel] Thinkpad hotkeys and USB audio not working after
 resume in 3.0.x
From: Pedro Ribeiro <pedrib@gmail.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 September 2011 13:26, Pedro Ribeiro <pedrib@gmail.com> wrote:
> On 1 September 2011 13:16, Nigel Cunningham <nigel@tuxonice.net> wrote:
>> Hi Pedro.
>>
>> On 01/09/11 20:36, Pedro Ribeiro wrote:
>>> Hi,
>>>
>>> I'm hitting a bug with my thinkpad T400. After resuming from Hibernate,
>>> the thinkpad hotkeys and my USB audio card do not work at all.
>>> Suspending to RAM and resuming seem to solve the problem, but after
>>> another hibernation it comes back again.
>>>
>>> This only happens with TuxOnIce but not with the vanilla kernel.
>>>
>>> Rafael, can you please point out from the top of your head if there was
>>> any change that could have caused this?
>>
>> Sorry for my slowness in getting back to you Pedro.
>>
>> When you invoke swsusp, is it in exactly the same way that TuxOnIce is
>> invoked? I'm wondering whether modules are unloaded and services stopped
>> in one scenario that are handled differently in the other.
>>
>> Regards,
>>
>> Nigel
>> --
>> Evolution (n): A hypothetical process whereby improbable
>> events occur with alarming frequency, order arises from chaos, and
>> no one is given credit.
>>
>
> Hi Nigel,
>
> Thanks for your response.
>
> I just tried using echo disk > /sys/power/state using both methods
> (swsusp and ToI) and the result is the same.
>
> With swsusp the keys and the USB interface work fine, but with ToI
> they stop working until I suspend to RAM.
>
> Regards,
> Pedro
>

Forgot to say, I tried reverting "PM / Runtime: Rework runtime PM
handling during driver
 removal" but it didn't help.

Regards,
Pedro
