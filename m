Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0ENBNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 21:13:25 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:64848 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab0ENBNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 21:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tl96a/DE532scCShGF8esW9b7nT9TMehlS3vzq3VVRFwzsiZwwWWhgM7COGaONeXvf
         2DUVMyXJYGdAAZEOup4u2Q+1AD4K2xEzSKyPQrM2lIPPSXgW6TEIwDXiZx4Qe5WJuxYw
         fuN28oMsio636PqqzNJqj9Pj/oKG2Gx8vZ1C8=
Message-ID: <4BECA3AE.4070607@gmail.com>
Date: Thu, 13 May 2010 18:13:18 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
References: <4BEC7A84.3010503@gmail.com> <AANLkTinKoMxdkPYQA_AblpByL6zAiAP5hv2M3Jn2R3hM@mail.gmail.com> <4BEC9E6B.30809@gmail.com> <201005141008.20667.br1@einfach.org>
In-Reply-To: <201005141008.20667.br1@einfach.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/10 18:08, Bruno Randolf wrote:
> On Friday 14 May 2010 09:50:51 Justin P. Mattock wrote:
>> On 05/13/10 17:28, Luis R. Rodriguez wrote:
>>> On Thu, May 13, 2010 at 5:21 PM, Justin P. Mattock
>>>
>>> <justinmattock@gmail.com>   wrote:
>>>> On 05/13/10 16:01, Luis R. Rodriguez wrote:
>>>>> On Thu, May 13, 2010 at 3:17 PM, Justin P. Mattock
>>>>>
>>>>> <justinmattock@gmail.com>     wrote:
>>>>>> not sure what this is, but while at a convention
>>>>>> I was trying to access the internet and(below is
>>>>>> full dmesg) this showed up.
>>>>>>
>>>>>> After receiving this, I sat and tried to re-create
>>>>>> my steps to reproduce but had no luck(was even going
>>>>>> todo a bisect n the spot if I could re-create).
>>>>>
>>>>> OK this stuff is hard to reproduce it seems.. you have an Atheros
>>>>> AR5418 MAC/BB Rev:2 AR5133 RF Rev:81, what kconfig option do you use
>>>>> to get the poison stuff? I am just surprised we haven't seen it
>>>>> ourselves yet. Let me make sure all of us get this kconfig option
>>>>> enabled.
>>>>>
>>>>>     Luis
>>>>
>>>> CONFIG_ATH_COMMON=m
>>>> # CONFIG_ATH_DEBUG is not set
>>>> CONFIG_ATH5K=m
>>>> # CONFIG_ATH5K_DEBUG is not set
>>>> CONFIG_ATH9K_HW=m
>>>> CONFIG_ATH9K_COMMON=m
>>>> CONFIG_ATH9K=m
>>>> # CONFIG_ATH9K_DEBUGFS is not set
>>>>
>>>> if you need my .config let me know.
>>>> (I can try again reproducing, but man
>>>> just doesn't easily fire off).
>>>
>>> Oh I mean the config options to enable the poison rant.
>>>
>>>     Luis
>>
>> shoot.. not sure how to grep for the right info
>> in the .config for you, heres what grepping for COFIG_DEBUG
>> looks like:
>> CONFIG_DEBUG_FS=y
>> CONFIG_DEBUG_KERNEL=y
>> CONFIG_DEBUG_RT_MUTEXES=y
>> CONFIG_DEBUG_PI_LIST=y
>> CONFIG_DEBUG_SPINLOCK=y
>> CONFIG_DEBUG_MUTEXES=y
>> CONFIG_DEBUG_BUGVERBOSE=y
>> CONFIG_DEBUG_MEMORY_INIT=y
>> CONFIG_DEBUG_STACKOVERFLOW=y
>
> oh, this reminds me of a similar report we had for ath5k:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=15861
>
> the subject on this mailing list was "ath5k misbehaving affecting other kernel
> parts unrelated?"
>
> bruno
>

Could be.. From what I remember
all I was doing was switching from
one wireless network to another
(then opening firefox to sign my life away).

eventually giving up, realizing I needed 99
big ones to be back on the grid.
(beauty of git though is I don't need
to be online to work).

Justin P. Mattock
