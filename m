Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1ASEGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 23:06:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40373 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1ASEGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 23:06:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=GgkwxkXC1giTDKnlgEI8/F2hU52ynY5DU6d+OCLgKlHEHq6eAyXtq5v74yZDGn+8Ew
         iuvPQ9TnhYQNYaXkgmhGPoqB1NV947+SrjTjd4DbTdXRotKOx7vufadkCHDkpiVL4FiQ
         LBFF5/fQuCrFSnk15ThAkZBlvLACi/F7nO+ZU=
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-Id: <C43C6920-D802-4893-A099-62014123390A@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <AANLkTin+Div6HoAJdFOfqRFSMyxqx7ft7mcteXomaV_Y@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: Linux 2.6.38-rc1
Date: Tue, 18 Jan 2011 20:05:57 -0800
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com> <AANLkTimp0UcWi68N5Jv_hUww9PhGVgCzY0qYLETc8Dj_@mail.gmail.com> <1161CC5A-C8CA-477E-B2CE-7870F8E634EE@gmail.com> <AANLkTin+Div6HoAJdFOfqRFSMyxqx7ft7mcteXomaV_Y@mail.gmail.com>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 18, 2011, at 7:53 PM, Linus Torvalds wrote:

> On Tue, Jan 18, 2011 at 7:42 PM, Justin Mattock <justinmattock@gmail.com 
> > wrote:
>>
>> wheres the changelog? (gotta narcissistically check to see if I  
>> made it
>> in)..
>
> I only do changelogs in the email if they are small enough to be
> reasonable. -rc1 never is. -rc2 seldom is. Usually it's -rc3 and up.
> In this case, even just the shortlog would have been about ten
> thousand lines and 480kB, so it really isn't going to fly through lkml
> (and nobody would read it all anyway)
>

never realized that... always thought there was a changelog in your  
posts for releases

> But you can get git, and do
>
>   git shortlog v2.6.37..v2.6.38-rc1
>
> to get the shortlog. Or you can download the whole changelog from
> kernel.org next to the kernel sources. The git approach is better,
> because you can ask for the log for just specific files or
> subdirectories that you are interested in, which turns the flood into
> something much more manageable.
>

git is where Ill see then, and/or if you post it on an email

> But, since you asked, we can just do
>
>    git shortlog --author=justin v2.6.37..v2.6.38-rc1
>

a new way to use git...(nice!!)

> which is appended. Go Justin!
>
>               Linus
>
> PS. No. I will not make personalized shortlogs for everybody who asks.
>

no... thats not a good idea

> ---
> Justin P. Mattock (8):
>      staging: Fix typos in rt2860
>      spi/dw_spi Typo change diable to disable.
>      spi/topcliff: Typo fix threhold to threshold
>      media: comment typo fix diable -> disable.
>      wireless: comment typo fix diable -> disable.
>      m68k: fix comment typo diable -> disable.
>      drivers: fix comment typo diable -> disable.
>      ppc: fix comment typo singal -> signal

was wondering what happened to those.. all right... and Now have my  
answer!!

thanks for the response...

Justin P. Mattock
