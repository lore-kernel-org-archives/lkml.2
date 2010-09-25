Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab0IYVao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 17:30:44 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55146 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab0IYVam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 17:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=XX8nmPSvTE1Tw510NH7265RU4lbebgiTJ1IPill2LMyGxcTPbTEj8z7DS+P22fy/kC
         D8AejVR7ZWOshGo5KWhFRgrNrrwheiUbiryuYhfHlKEgTXe4SM9pEBQ2gzPgHrTSMsTm
         aLvjMQu6eQoS22rnv7DjQ3DRnZBPmVZOPXllQ=
Message-ID: <4C9E6A09.10007@gmail.com>
Date: Sat, 25 Sep 2010 14:30:49 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org,
        linux-ide@vger.kernel.org
Subject: Re: [RFC 2/3 v3]update web addresses in stagging
References: <1285373337-10945-1-git-send-email-justinmattock@gmail.com> <1285373337-10945-2-git-send-email-justinmattock@gmail.com> <20100925003406.GA30029@kroah.com> <4C9D47AC.6000002@gmail.com> <20100925204736.GD25677@one-eyed-alien.net>
In-Reply-To: <20100925204736.GD25677@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2010 01:47 PM, Matthew Dharm wrote:
> On Fri, Sep 24, 2010 at 05:51:56PM -0700, Justin P. Mattock wrote:
>> On 09/24/2010 05:34 PM, Greg KH wrote:
>>> On Fri, Sep 24, 2010 at 05:08:56PM -0700, Justin P. Mattock wrote:
>>>> The below patch, is a simple fix to a broken web address not using a
>>>> period in it's
>>>> name. I'll leave this up to you guys if you want to use it...
>>>>
>>>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>
>>> I'll queue it up, thanks.
>>>
>>> Oh, it's "staging", not "stagging" as you have up there in the Subject:
>>> :)
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> shoot... and I actually changed it from staging to stagging thinking
>> that was correct..(duh)..
>>
>> Anyways alright.. I'll exclude this one if the other sets get finalized.
>
> One random suggestion:  Perhaps you should include a date here?  i.e. "URL
> blah blah blah (as of Sept 2010)"
>
> That way, people have some idea how much they can trust that URL without
> having to dig into the kernel history to see when it was last changed.
>
> Matt
>


well.. as it stand right now doing grep -Re "http" in all the 
directories(minus COPYING/MAINTAINERS) gave me a little over 2000
addresses to check(not so bad, only a few days worth of checking(finding 
the broken address is time consuming)).. so I could go back and do this 
for all of them except the webarchive addresses that are broken(maybe 
put a tag on them saying use_webarchive or something).
then there is the question of how much more bloated will the kernel get 
with such a thing(I'm guessing not much, but then again you never know).

Justin P. Mattock
