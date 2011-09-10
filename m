Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992Ab1IJTmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 15:42:40 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:54709 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815Ab1IJTmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 15:42:39 -0400
MIME-Version: 1.0
In-Reply-To: <yunbousl9f5.fsf@aiko.keithp.com>
References: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com>
	<yunbousl9f5.fsf@aiko.keithp.com>
Date: Sat, 10 Sep 2011 21:42:39 +0200
Message-ID: <CAC9WiBgaaCydvzmNgxyqYnuzH-32hhexu7TNJUai1VEnowDcCQ@mail.gmail.com>
Subject: Re: 3.1-rc5 is the worst
From: Francis Moreau <francis.moro@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 5:11 PM, Keith Packard <keithp@keithp.com> wrote:
> On Sat, 10 Sep 2011 11:57:06 +0200, Francis Moreau <francis.moro@gmail.com> wrote:
>
>> 3/ video: Intel Corporation Core Processor Integrated Graphics
>> Controller (rev 18) drived by 'i915': sometime after resuming or after
>> leaving the black screensaver, the screen seems to be frozen and I
>> need to switch to tty1 and switch back to the graphic screen in order
>> to make the screen refreshed again.
>
> Can you try disabling fbc and see if this helps?
>
> i915.i915_enable_fbc=0
>
> We've gotten a few minor regression reports that this fixes; we're
> working on isolating the cause if possible.

of course I'm having hard time to reproduce now :)

Any idea how can I force the screen to sleep ?

Setting the timer to 1 min with the gnome interface doesn't work....

Thanks
-- 
Francis
