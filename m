Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1JYIg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:36:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61168 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1JYIg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:36:26 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxK-OJXDNsJ37wSN+MGhGp-j50BX-52eEjBHVSepTTm9w@mail.gmail.com>
References: <alpine.DEB.2.00.1110242118500.9114@ayla.of.borg>
	<CA+55aFxK-OJXDNsJ37wSN+MGhGp-j50BX-52eEjBHVSepTTm9w@mail.gmail.com>
Date: Tue, 25 Oct 2011 10:36:25 +0200
X-Google-Sender-Auth: Zz7xF2SFn-IIE0AhdbhhTXIt7mM
Message-ID: <CAMuHMdURW7QT+2tEfZDeH_z-OJEksx_j2gRg2BN-NfoXFTdOdA@mail.gmail.com>
Subject: Re: [git pull] m68k updates for 3.2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Ungerer <gerg@uclinux.org>, Greg Ungerer <gerg@snapgear.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Oct 25, 2011 at 09:38, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Oct 24, 2011 at 9:26 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>>
>>  git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
>
> Please fix your pull script. There's an extraneous ":" there. Spot it?

Sorry, I should _start_ scripting it.

> Also, while I see these commits in linux-next, I also see that they
> have been rebased in the last day, which means that looking for them
> in linux-next is actually much harder than they need to be.
>
> In other words - WHY DID YOU REBASE? It just generates more work for
> me, and adds absolutely zero value.

I always rebase m68k-queue (of which the for-{linus,next,x.y} are subsets)
to the latest tagged release, as this allows to:
  - check that m68k-queue and master are (almost) identical, to detect
    mismerges on master, and misrebases on m68k-queue,
  - clearly see which commits in m68k-queue have bubbled up to the for-*
    queues.

If you really hate this, I'll break these rules for for-linus, and
make sure it's
identical to yesterday's for-next.

> I pulled it, but some of the silly details annoyed me.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
