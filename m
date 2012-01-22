Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2AVKfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 05:35:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44644 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2AVKfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 05:35:52 -0500
MIME-Version: 1.0
In-Reply-To: <20120120151452.2fe57bb87218f575e8909caf@canb.auug.org.au>
References: <CA+55aFwWEhobGDzkuRoXaS37y3tMU41ExhiR+vCa68cUNRehKg@mail.gmail.com>
	<20120120151452.2fe57bb87218f575e8909caf@canb.auug.org.au>
Date: Sun, 22 Jan 2012 11:35:50 +0100
X-Google-Sender-Auth: hwZ9l5caO3LJIEUmG57TYUpmrxs
Message-ID: <CAMuHMdVMHnTHpwzCRaRZmTBLg9z+DJD1qJ7O3A6U3CJGFgN1Wg@mail.gmail.com>
Subject: Re: Linux 3.3-1 out - merge window closed
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 05:14, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Thu, 19 Jan 2012 15:58:28 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> (Stats for those that like them: 20% arch updates (arm, power, mips,
>> x86), 60% drivers (networking - wireless in particular, staging,
>> media, dri, sound, misc - including getting rid of 'struct sysdev'),
>> and 20% random stuff: filesystems, networking, perf etc)
>
> More stats for the bored:
>
> (I don't count merge commits below and everything is relative to v3.2)
>
> Of the 8899 commits in v3.3-rc1, 6918 were in next-20120106 (the first
> -next based on v3.2).  A further 792 commits have the same subject line as
> commits in next-20120116 and a further 16 have the same patch-id.
>
> This leaves 1174 commits (13%) in v3.3-rc1 that were not in next-20120106
> for some reason (not too bad really, I guess).  Some will clearly be bug
> fixes, of course.  Some will be quilt trees (probably rebased before
> being sent to Linus).  Some will be patches that depend on work by others.

Even more stats for the bored (more details in "Build regressions/improvements
in v3.3-rc1"): 80 new build errors were introduced.

(Un?)fortunately not all of them can be attributed to the changesets
that skipped
-next, as I know of several that affected the builds I'm most
interested in in -next.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
