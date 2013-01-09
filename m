Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3AIH20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:28:26 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48082 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3AIH2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:28:25 -0500
Message-ID: <50ED1C12.2090608@gmail.com>
Date: Wed, 09 Jan 2013 11:28:18 +0400
From: Lijo Antony <lijo.kernel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i915_hangcheck_hung problem with 3.8-rc2+ (Linus's latest tree)
References: <20130108223611.GA19672@kroah.com> <20130109003824.GA21075@kroah.com> <CAPM=9tw3o0e_3cRUFntwddxsWMsYkVKe1b5gDQhxijYKU=9m5g@mail.gmail.com> <20130109042533.GA9164@kroah.com> <CAPM=9tyB4aKK2Z3-h9yEXLWvrnKGjxH2DaOHp8uA0mNNZQiVWQ@mail.gmail.com>
In-Reply-To: <CAPM=9tyB4aKK2Z3-h9yEXLWvrnKGjxH2DaOHp8uA0mNNZQiVWQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 09:31 AM, Dave Airlie wrote:
> On Wed, Jan 9, 2013 at 2:25 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Wed, Jan 09, 2013 at 01:42:39PM +1000, Dave Airlie wrote:
>>>>> Hi all,
>>>>>
>>>>> I've hit this 3 times today on Linus's latest 3.8-rc2+ tree:
>>>>>
>>>>> [11868.414648] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
>>>>> [11868.414655] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
>>>>> [11870.408342] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
>>>>> [11870.408412] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
>>>>> [11870.408414] [drm:i915_reset] *ERROR* Failed to reset chip.
>>>>> [11883.083225] gnome-shell[19396]: segfault at 218 ip 00007feef5f32333 sp 00007ffffc1dc930 error 4 in i965_dri.so[7feef5ecb000+d0000]
>>>>
>>>> I just hit this again.  And, as the kernel was asking for it, attached
>>>> is the i915_error_state file, compressed due to the size of it.
>>>>
>>> Welcome to sink hole that is
>>> https://bugs.freedesktop.org/show_bug.cgi?id=55984
>>>
>>> 3 months and ticking, Intel guys are all running away from it saying
>>> they can't reproduce, everyone else on planet seems to reproduce quite
>>> easily.
>>>
>>> Its generally considered a bug in the relocation/shrinker/no idea category,
>>
>> Ugh, what a mess.
>>
>>> Assuming you have an Ironlake machine which I'm going to guess you do.
>>
>> I don't know, it's an old i5 machine that has never had any video
>> problems for many years now.  How do I tell?
>
> lspci -nn probably an 8086:0046 device.
>
> Old i5 probably means original i5 which means ironlake.
>

I have also seen this a couple of times on 3.7 and 3.8-rc1.
Most of the times I was watching youtube video in chrome. Nothing 
crashed though(I am not running gnome shell). System recovered after few 
seconds.

I didn't see this on 3.8-rc2 yet, probably because I haven't watched any 
video.

-lijo



