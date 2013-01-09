Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab3AIFbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 00:31:51 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63915 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3AIFbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 00:31:50 -0500
MIME-Version: 1.0
In-Reply-To: <20130109042533.GA9164@kroah.com>
References: <20130108223611.GA19672@kroah.com>
	<20130109003824.GA21075@kroah.com>
	<CAPM=9tw3o0e_3cRUFntwddxsWMsYkVKe1b5gDQhxijYKU=9m5g@mail.gmail.com>
	<20130109042533.GA9164@kroah.com>
Date: Wed, 9 Jan 2013 15:31:50 +1000
Message-ID: <CAPM=9tyB4aKK2Z3-h9yEXLWvrnKGjxH2DaOHp8uA0mNNZQiVWQ@mail.gmail.com>
Subject: Re: i915_hangcheck_hung problem with 3.8-rc2+ (Linus's latest tree)
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 2:25 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Jan 09, 2013 at 01:42:39PM +1000, Dave Airlie wrote:
>> >> Hi all,
>> >>
>> >> I've hit this 3 times today on Linus's latest 3.8-rc2+ tree:
>> >>
>> >> [11868.414648] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
>> >> [11868.414655] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
>> >> [11870.408342] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
>> >> [11870.408412] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
>> >> [11870.408414] [drm:i915_reset] *ERROR* Failed to reset chip.
>> >> [11883.083225] gnome-shell[19396]: segfault at 218 ip 00007feef5f32333 sp 00007ffffc1dc930 error 4 in i965_dri.so[7feef5ecb000+d0000]
>> >
>> > I just hit this again.  And, as the kernel was asking for it, attached
>> > is the i915_error_state file, compressed due to the size of it.
>> >
>> Welcome to sink hole that is
>> https://bugs.freedesktop.org/show_bug.cgi?id=55984
>>
>> 3 months and ticking, Intel guys are all running away from it saying
>> they can't reproduce, everyone else on planet seems to reproduce quite
>> easily.
>>
>> Its generally considered a bug in the relocation/shrinker/no idea category,
>
> Ugh, what a mess.
>
>> Assuming you have an Ironlake machine which I'm going to guess you do.
>
> I don't know, it's an old i5 machine that has never had any video
> problems for many years now.  How do I tell?

lspci -nn probably an 8086:0046 device.

Old i5 probably means original i5 which means ironlake.

Dave.
