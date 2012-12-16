Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2LPKTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 05:19:11 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43424 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2LPKTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 05:19:09 -0500
MIME-Version: 1.0
In-Reply-To: <50CC687F.6060305@westnet.com.au>
References: <1355521700.18402.7@driftwood>
	<50CC687F.6060305@westnet.com.au>
Date: Sun, 16 Dec 2012 11:19:07 +0100
X-Google-Sender-Auth: ruFQgMAXdXX2KXj2lCnhzKkTOw8
Message-ID: <CAMuHMdWSFphLjm6Lwh15nj+mSp1B_JqavU8zygeK0UwEvwu-nA@mail.gmail.com>
Subject: Re: [git pull] m68k updates for 3.8
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gregungerer@westnet.com.au>
Cc: Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gerg@uclinux.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 1:09 PM, Greg Ungerer
<gregungerer@westnet.com.au> wrote:
> On 12/15/2012 07:48 AM, Rob Landley wrote:
>> On 12/14/2012 06:04:51 AM, Greg Ungerer wrote:
>>> Hi Rob,
>>>> Somebody got one of my images to boot under aranym but they had to patch
>>>> the kernel fairly extensively to add the emulated device support that
>>>> emulator provided. It doesn't emulate real devices the way qemu does,
>>>> but qemu doesn't fully emulate the processor (just coldfire in
>>>> mainline)...
>>>
>>> I use aranym for testing m68k. Though I don't really pound to heavily
>>> on the devices. I really only cross-compile small systems for testing
>>> on it.
>>
>> What kernel config do you use for aranym? I don't see an an aranym entry
>> in
>> arch/m68k/configs, and I stopped using it precisely because it required
>> several large patches to add emulated device support for everything from
>> serial console to block devices. (There was a kernel upgrade, it broke,
>> I cut a release without it. Pretty much the same reason I stopped using
>> squashfs for a year or so until it finally got merged.)
>
> arch/m68k/configs/atari_defconfig

The normal defconfig (aka multi_defconfig) should also work.

> AranyM is an Atari emulator. As far as I know all the special device
> support has been merged into mainline now.

Indeed, as of v2.6.39.

Even without that support, an Atari kernel should work (albeit slower), except
for networking.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
