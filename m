Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967575Ab2EQSmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:42:13 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47190 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967533Ab2EQSmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:42:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAOZdJXW2jmFG8hkBRMAsO-CJ3ruMd28LqS0b-BGZTU7FnpRi3Q@mail.gmail.com>
References: <1337157034-22773-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdUtL4_mv-e-EQAZmNcb9dAT=PXB59i7Vuj2vf8NnaBFzQ@mail.gmail.com>
	<1337212281.30558.17.camel@pasglop>
	<4FB535D3.7000106@freescale.com>
	<CAOZdJXW2jmFG8hkBRMAsO-CJ3ruMd28LqS0b-BGZTU7FnpRi3Q@mail.gmail.com>
Date: Thu, 17 May 2012 20:42:08 +0200
X-Google-Sender-Auth: NMEzntaTml5QkSvlZJle51lqHyk
Message-ID: <CAMuHMdVszy2sk6f045krqr=PPQFnd-GrtJYJMQCCPzkq-65psg@mail.gmail.com>
Subject: Re: Re: Build regressions/improvements in v3.4-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tabi Timur-B04825 <B04825@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <linuxppc-dev@ozlabs.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 7:52 PM, Tabi Timur-B04825 <B04825@freescale.com> wrote:
> On Thu, May 17, 2012 at 12:30 PM, Timur Tabi <timur@freescale.com> wrote:
>
>> Anyway, I think I see what the problem is, but it does appear when I use
>> the normal defconfigs.  What .config was being used?
>
> I meant to say that it does NOT appear.

powerpc randconfig.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
