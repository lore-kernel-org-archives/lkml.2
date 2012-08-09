Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab2HISeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:34:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60871 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab2HISes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:34:48 -0400
MIME-Version: 1.0
In-Reply-To: <CA+h=+L-W0-iBFouqqSFeU9iGU0rsHpV7e853i_mgo=RV9h=MDA@mail.gmail.com>
References: <CA+h=+L8geO5kM8VV-+VFkSrvBRJEs31V9OaQ6g98hirRKJWq1g@mail.gmail.com>
 <alpine.LNX.2.00.1208082243271.10061@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1208082252550.10061@swampdragon.chaosbits.net> <CA+h=+L-W0-iBFouqqSFeU9iGU0rsHpV7e853i_mgo=RV9h=MDA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 9 Aug 2012 11:34:26 -0700
Message-ID: <CAErSpo7sHD=vLGmkS9Cd0cFxiGnBoY3Khcq9Fr33i6xKhhq43g@mail.gmail.com>
Subject: Re: PROBLEM: snd_hda_intel bug during boot
To: Alexei Kornienko <alexei.kornienko@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you can collect complete dmesg logs from the working kernel and the
broken kernel and post them, the differences might have a clue.  You
might also collect /proc/iomem and "lspci -vv" for both cases while
you're at it.

On Wed, Aug 8, 2012 at 10:38 PM, Alexei Kornienko
<alexei.kornienko@gmail.com> wrote:
> Hi,
>
> Yes it used to work with 2.6 kernel.
> Ok I will do a bisect and try to find the source of the problem.
> I'll notify you if I'll find something but don't expect it to be fast
> cause the problem happens on my home laptop (pretty old and rusty :) )
> and I also have a lot of other stuff to do.
>
> Regards,
> Alexei
>
> 2012/8/8 Jesper Juhl <jj@chaosbits.net>:
>> On Wed, 8 Aug 2012, Jesper Juhl wrote:
>>
>>> On Wed, 8 Aug 2012, Alexei Kornienko wrote:
>>>
>>> > Seems like I have a bug in audio driver on my laptop. Cause of this I
>>> > don't have any sound card detected.
>>> > Please find more details below:
>>> >
>>> > ** Version:
>>> > Linux version 3.2.0-29-generic-pae (buildd@roseapple) (gcc version
>>> > 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #46-Ubuntu SMP Fri Jul 27
>>> > 17:25:43 UTC 2012
>>> >
>>> Ok, so I openly admit that I have no clue as to what your problem might
>>> be. But, one thing I do know is that, a *lot* has changed since the 3.2
>>> kernel you are running and the most recent stable (3.5) kernel. So,
>>> perhaps you could test the 3.5 kernel and tell us if you still see the
>>> problem with that one or not?
>>> If you are feeling adventurous you could also try a snapshot of the latest
>>> Linus (to become 3.6) kernel and tell us your experiences with that...?
>>>
>> Also, if this used to work with an older kernel, then it would probably
>> be helpful if you could do a "git bisect" between the older (working)
>> kernel version and your current (broken) kernel version in order to zoom
>> in on the commit that broke things for you.
>>
>> --
>> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
>> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
>> Plain text mails only, please.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
