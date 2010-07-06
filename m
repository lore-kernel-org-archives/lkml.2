Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab0GFD16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 23:27:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59738 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab0GFD15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 23:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DDWfSPsAV5X3mdUFhnstyYsWuOZ/2BiXK4vEu0gh8gKrLBwOAyTvONwym/7tVTosjg
         Uh7WVmWwhDtJXRcx7PsdE8VuoF7CQEF3uoIb8nZDZm8E9TI78SymBLzCrCu38NPa7HLO
         cVOpXEguQI9hpKFIVuC3ujMDhujTnBlnBQaq8=
Message-ID: <4C32A2DF.4010500@gmail.com>
Date: Mon, 05 Jul 2010 20:28:31 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: Marvin <marvin24@gmx.de>, linux-kernel@vger.kernel.org,
       xorg-driver-ati@lists.x.org
Subject: Re: Radeon KMS doesn't work.
References: <20100703221056.GA17817@animx.eu.org>	<20100704231926.GA1780@animx.eu.org>	<201007051927.17001.marvin24@gmx.de>	<4C3221FA.6070507@gmail.com> <AANLkTil2pHW4C-g-DPKUy-yvDfB3fedQC270RfqL3Gnt@mail.gmail.com>
In-Reply-To: <AANLkTil2pHW4C-g-DPKUy-yvDfB3fedQC270RfqL3Gnt@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 07:34 PM, Xiaotian Feng wrote:
> On Tue, Jul 6, 2010 at 2:18 AM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> On 07/05/2010 10:27 AM, Marvin wrote:
>>>
>>> Hi Wakko,
>>>
>>> as nobody seems to have answered yet, I think it's better that you file a
>>> bug
>>> against the radeon driver (bugs.freedesktop.org, one bug for each defect).
>>> There may be similar bugs already, so please check this also.
>>>
>>> Thanks
>>>
>>> Marvin
>>>
>>> Am Montag 05 Juli 2010, 01:19:26 schrieb Wakko Warner:
>>>>
>>>> Wakko Warner wrote:
>>>>>
>>>>> I have a Dell Inspiron 5100 with an ATI Radeon Mobility M7 (7500 R100
>>>>> PCI ID 1002:4c57 sub 1028:0149).
>>>>>
>>>>> Immediately when radeon.ko is loaded, the screen goes blank (The
>>>>> backlight stays on).  I have fbcon compiled into the kernel (I also
>>>>> tried as module). I am unable to get the screen to work again until I
>>>>> reboot.  The logs did not appear to have any errors after the module
>>>>> loaded.  The system was still responsive on the network.
>>>>>
>>>>> I tried kernels 2.6.33 and 2.6.34.
>>>>>
>>>>> I can provide kernel output if needed.
>>>>
>>>> I need to add that if I use modeset=0, the screen does not blank.
>>>>
>>>> Also 2.6.34 (with modeset=0) doesn't do 3D very well on this system.
>>>>   Some
>>>> objects look ok, some are garbled, some do not appear at all.  The gears
>>>> from xscreensaver does not show up at all.
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>>
>> I've hit a couple of things with radeon as well.. the first was this:
>> http://lkml.org/lkml/2010/6/6/172
>> (if your hitting this issue, then the patch should work and/or it should
>> already be in the main tree).
>>
>> then a few days ago hit another:
>> https://bugzilla.kernel.org/show_bug.cgi?id=16335
>> (keep in mind still uncertain on a fix for this, reverting the commit gets
>> me up and running(I created a patch, but an umsure if it's a right
>> solution)).
>
> I think this is the same cases with (http://lkml.org/lkml/2010/7/5/44)
> And the fix for this bug is in -tip tree, commit 2463eb8
>
> Could you please try following patch?
> http://git.kernel.org/tip/2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
>

applied.. o.k. system started without hitting the crash I was 
experiencing!! Thanks for this.. I'll run this and let you know if I 
experience anything out of the ordinary..

>>
>> if none of these are what your hitting, then maybe(if you can) do a bisect
>> on this!
>>
>> Justin P. Mattock
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>

Tested-By: Justin P. Mattock <justinmattock@gmail.com>

I'll send this info over to the bug report so they know..and if things 
go good get this thing closed..

Justin P. Mattock
