Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1ASDyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 22:54:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab1ASDyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 22:54:06 -0500
MIME-Version: 1.0
In-Reply-To: <1161CC5A-C8CA-477E-B2CE-7870F8E634EE@gmail.com>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <AANLkTimp0UcWi68N5Jv_hUww9PhGVgCzY0qYLETc8Dj_@mail.gmail.com> <1161CC5A-C8CA-477E-B2CE-7870F8E634EE@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Jan 2011 19:53:44 -0800
Message-ID: <AANLkTin+Div6HoAJdFOfqRFSMyxqx7ft7mcteXomaV_Y@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc1
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 7:42 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>
> wheres the changelog? (gotta narcissistically check to see if I made it
> in)..

I only do changelogs in the email if they are small enough to be
reasonable. -rc1 never is. -rc2 seldom is. Usually it's -rc3 and up.
In this case, even just the shortlog would have been about ten
thousand lines and 480kB, so it really isn't going to fly through lkml
(and nobody would read it all anyway)

But you can get git, and do

   git shortlog v2.6.37..v2.6.38-rc1

to get the shortlog. Or you can download the whole changelog from
kernel.org next to the kernel sources. The git approach is better,
because you can ask for the log for just specific files or
subdirectories that you are interested in, which turns the flood into
something much more manageable.

But, since you asked, we can just do

    git shortlog --author=justin v2.6.37..v2.6.38-rc1

which is appended. Go Justin!

               Linus

PS. No. I will not make personalized shortlogs for everybody who asks.

---
Justin P. Mattock (8):
      staging: Fix typos in rt2860
      spi/dw_spi Typo change diable to disable.
      spi/topcliff: Typo fix threhold to threshold
      media: comment typo fix diable -> disable.
      wireless: comment typo fix diable -> disable.
      m68k: fix comment typo diable -> disable.
      drivers: fix comment typo diable -> disable.
      ppc: fix comment typo singal -> signal
