Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3AIDml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 22:42:41 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:42418 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079Ab3AIDmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 22:42:40 -0500
MIME-Version: 1.0
In-Reply-To: <20130109003824.GA21075@kroah.com>
References: <20130108223611.GA19672@kroah.com>
	<20130109003824.GA21075@kroah.com>
Date: Wed, 9 Jan 2013 13:42:39 +1000
Message-ID: <CAPM=9tw3o0e_3cRUFntwddxsWMsYkVKe1b5gDQhxijYKU=9m5g@mail.gmail.com>
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

>> Hi all,
>>
>> I've hit this 3 times today on Linus's latest 3.8-rc2+ tree:
>>
>> [11868.414648] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
>> [11868.414655] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
>> [11870.408342] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
>> [11870.408412] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
>> [11870.408414] [drm:i915_reset] *ERROR* Failed to reset chip.
>> [11883.083225] gnome-shell[19396]: segfault at 218 ip 00007feef5f32333 sp 00007ffffc1dc930 error 4 in i965_dri.so[7feef5ecb000+d0000]
>
> I just hit this again.  And, as the kernel was asking for it, attached
> is the i915_error_state file, compressed due to the size of it.
>
Welcome to sink hole that is
https://bugs.freedesktop.org/show_bug.cgi?id=55984

3 months and ticking, Intel guys are all running away from it saying
they can't reproduce, everyone else on planet seems to reproduce quite
easily.

Its generally considered a bug in the relocation/shrinker/no idea category,

Assuming you have an Ironlake machine which I'm going to guess you do.

Dave.
