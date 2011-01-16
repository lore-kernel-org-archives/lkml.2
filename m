Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1APTFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 14:05:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36000 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab1APTFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 14:05:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J8GpdmHP4omARFNOi3cIE7u6qtoSlfg02IP/m2RsKqevCZUd4yB4eR+Zo3IhTK85y2
         y20RU6t7BbqY7LrKh1N8xpUoiiRv2DAaFwxSIMOLnhe0NxmB6SogsESgZ511jQwcSuxY
         YKUPCdoFhdua+xFIbAR+Rsr1fL38j8MXsI760=
MIME-Version: 1.0
In-Reply-To: <AANLkTimyrHqDpG4DmLym5AeHBbWziETDXjvBU+eaFfcb@mail.gmail.com>
References: <AANLkTimBXn8zoQdPE0t-P5FZ_rLi+1jzuzG+WxeiCwFD@mail.gmail.com>
	<AANLkTim6u9WUE7RkXUYEbTqftZ8gmB1xTYD_H8c7yhpu@mail.gmail.com>
	<AANLkTinVDdUX70E12fqJBBsd+zKDF4zpnG4YSUhCuQCD@mail.gmail.com>
	<AANLkTimG+61dj-KNeAJZLta4+r1TyXyo1nO7VwJnxUW7@mail.gmail.com>
	<AANLkTikfp56XBE+B0hvvYD2nSJXpQ65XO7gwL2ZLU5uU@mail.gmail.com>
	<AANLkTimyrHqDpG4DmLym5AeHBbWziETDXjvBU+eaFfcb@mail.gmail.com>
Date: Sun, 16 Jan 2011 21:03:36 +0200
Message-ID: <AANLkTim5-oQO4i7bc5mZZogXfuiHc_qk6S1Bz1eA83__@mail.gmail.com>
Subject: Re: Please revert nouveau.
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 8:56 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Jan 16, 2011 at 10:50 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>>
>> after
>> git revert dfe63bb0ad9810db13aab0058caba97866e0a681
>
> You are aware that that was already reverted yesterday? See commit 3632ef89.
>
>> and
>>
>> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
>> index 5c4f9b9..2aad663 100644
>> --- a/drivers/gpu/drm/drm_fb_helper.c
>> +++ b/drivers/gpu/drm/drm_fb_helper.c
>> @@ -816,6 +816,7 @@ int drm_fb_helper_set_par(struct fb_info *info)
>>                        mutex_unlock(&dev->mode_config.mutex);
>>                        return ret;
>>                }
>> +               drm_fb_helper_fill_fix(info, fb_helper->fb->pitch,
>> fb_helper->fb->depth);
>>        }
>>        mutex_unlock(&dev->mode_config.mutex);
>>
>> I have an partial working sistem.
>
> What does "partial working system" even MEAN?
>
> Anca, stop emailing worthless crap. Tell what the problems are. And cc
> the right people rather than asking me personally to just "revert"
> without even saying what the problem is. And if you feel like they
> have been ignoring you, then I have a clue for you: I bet they have
> been frustrated by the same things I am frustrated by.
>
> IOW, do a nice proper bug-report. Do it to the right people. Include
> useful information, and remember that the developers DO NOT see the
> problem you have (if they did, they'd not have done the changes), so
> "doesn't work" or "the boot screen is not ok" is not something anybody
> is ever going to find useful.
>
>         Linus
>

Linus, I am a beginner, I will try to be more useful in the future.
