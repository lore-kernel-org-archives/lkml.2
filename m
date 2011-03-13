Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab1CMRNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 13:13:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49295 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab1CMRNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 13:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=Ddoo5Pw3UqD9VD8e6YuKQucZY2ZbKdZKJkqBzcjKK+82f4Q0GjwWOCAlQeUAeQwYYk
         E4B7HK6A7G52Ap/aDIN7aW0xzYM3aVPoLry3vgYBo00rk29jo5LPv+PwsLSdwvAvU6Gu
         jEclwqdwPkTvTai6F9AA8KhRajLEiXr/YR5VE=
Message-ID: <4D7CFB3B.8060008@linaro.org>
Date: Sun, 13 Mar 2011 17:13:31 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
References: <20110312222633.27020.19543.stgit@otae.warmcat.com> <201103131141.07380.rjw@sisk.pl> <4D7CB15A.6030203@linaro.org> <201103131353.54612.rjw@sisk.pl> <4D7CC4D0.90305@linaro.org> <20110313161528.GB10718@kroah.com>
In-Reply-To: <20110313161528.GB10718@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 04:15 PM, Somebody in the thread at some point said:
> On Sun, Mar 13, 2011 at 01:21:20PM +0000, Andy Green wrote:
>> On 03/13/2011 12:53 PM, Somebody in the thread at some point said:
>>
>>>>>> This _really_ should just use the device tree stuff, that is what it is
>>>>>> for, please don't duplicate it here in a not-as-flexible way.
>>>>>
>>>>> I agree.
>>>>>
>>>>> @Andy: If it doesn't work for you for some reason, please let us know the
>>>>> usage case that is not covered (in detail).
>>>>
>>>> The device tree stuff does not yet exist in a workable way,
>>>> platform_data is established everywhere except USB bus.  Device tree
>>>> brings in bootloader version as a dependency: this method doesn't.
>>>
>>> It is not the same device tree we are talking about. :-)
>>>
>>> I mean device hierarchy (and I guess Greg meant the same).
>>
>> I see.  Elsewhere on the previous thread people were proposing to
>> use New Shiny Device Tree, hence the confusion.
>
> Yes, I meant the "new shiny device tree" work from Grant, who in an
> earlier message, said that this could all be done using that instead of
> your proposal.

That is what I took you to mean, since I already use oldstyle device 
tree as far as I could see it was possible.  So I have no idea what 
Rafael thought you or he meant by strongly agreeing with you when he was 
mistaken that thought you meant oldstyle device tree.  Anyway never mind.

Well I never heard mentioned before that Device Tree targets 
asynchronously probed device configuration.  If it does, and can do the 
same effective as the first patchset, then I guess that will (when it 
exists) fulfil a similar job and that'd be fine.

But what this overall patch set does in panda.c, usbnet and smsc95xx 
will need the same work done on it either way to deliver the same new 
configuration features in the driver side, via Shiny New Device Tree or 
whatever.

So when there's a bit more of Device Tree in evidence, are you going to 
accept Device-tree based patches in usbnet etc along these lines, or 
does that trigger the "do it in userspace" response, in which case we 
are both wasting each others' time continuing to discuss this at all?

-Andy
