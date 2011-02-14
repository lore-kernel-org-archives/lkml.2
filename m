Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1BNBOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 20:14:47 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40808 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1BNBOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 20:14:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=XDGmQ65vesVKTNOpP7rTpEmTnfYjOMUQQSWS+2tB7xO9GwEZk4sqGsgqHdeQuFTUPP
         S5PP8j20OKZGzsQ1hNZ9QeVJLYWY68+FESnFjiUQVoxoGkvrw1AwGOiRS4exDUhcPnVN
         gwp8znALc0ZcO3mu9z83akAQ21UMXA4v67TrU=
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Message-Id: <705ECE04-641E-4C3A-B3D3-B5D512AA98CF@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
In-Reply-To: <AANLkTikrZZ6i6di-c0zBav0zT5OOvmOXvX7SAXTW18z+@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen flicker like its broken or half plugged in
Date: Sun, 13 Feb 2011 17:14:35 -0800
References: <4D51AD03.7030401@gmail.com> <AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com> <AANLkTimBwM=iacwPosrYXU_jN=DXnEkWL3jvFcarDN23@mail.gmail.com> <B44733BE-E28B-441E-9E6B-AE9B0C8D7E45@gmail.com> <AANLkTimdE6G=qf+wLLSogma-BbH9J0_DYRv7aJkP9P64@mail.gmail.com> <AANLkTi=Ppzicpz5a6AO5rrGkv=j3HPmiB7Er4VGj4OVU@mail.gmail.com> <C0E6BA6B-174B-4930-A5C5-7DB87FDFAD1F@gmail.com> <AANLkTinca2027s9-g0tLabBMj4fr2+e=xgUSymBqvv1o@mail.gmail.com> <1838D776-BF70-4ABE-98CB-EFDCF828F6CF@gmail.com> <AANLkTikrZZ6i6di-c0zBav0zT5OOvmOXvX7SAXTW18z+@mail.gmail.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 13, 2011, at 3:46 PM, Alex Deucher wrote:

> On Sun, Feb 13, 2011 at 12:28 AM, Justin Mattock
> <justinmattock@gmail.com> wrote:
>>
>> On Feb 11, 2011, at 5:15 PM, Alex Deucher wrote:
>>
>>> On Fri, Feb 11, 2011 at 10:57 AM, Justin Mattock
>>> <justinmattock@gmail.com> wrote:
>>>>
>>>>>
>>>>> Better yet, can you try the attached patch on top of 2.6.38-rc4 or
>>>>> newer?
>>>>>
>>>>> Alex
>>>>>
>>>>
>>>> o.k. applied that patch... unfortunately Im seeing the flickering  
>>>> screen
>>>> and
>>>> the crud shows up..
>>>> initially during boot everything looked fine, its when I  
>>>> suspended the
>>>> machine, upon wake-up
>>>> the flickering occurred.
>>>> kernel version is the current: 2.6.38-rc4-00107-gaa502b4
>>>
>>> Can you try this patch?  Try uncommenting the following lines to see
>>> if either of those flags work any better.  Try them individually and
>>> together if possible and report back which, if any, helps.
>>>
>>> /*pll->flags |= RADEON_PLL_PREFER_MINM_OVER_MAXP;*/
>>>
>>> /*if (ASIC_IS_AVIVO(rdev))
>>>       pll->flags |= RADEON_PLL_USE_FRAC_FB_DIV;*/
>>>
>>> Thanks!
>>>
>>> Alex
>>>
>>>>
>>>> Justin P. Mattock
>>>>
>>> <0001-drm-radeon-kms-hopefully-fix-pll-issues-for-real-v2.patch>
>>
>>
>> alright.. again out of my office trying to make a living!!
>> Anyways I applied the two earlier patches, and added the previous  
>> post's
>> patch as well
>> (everything runs o.k. s2r etc...)
>> I can try for the above and see if I can pinpoint the piece of code  
>> that is
>> causing this(hopefully)
>
> The attached patch is what I'm proposing to go upstream.  Please test
> and let me know if it works ok for you.
>
> Alex


alright... bisect done, but something went wrong(must redu later)..  
Anyways with your patch applied
everything looks good

Justin P. Mattock
