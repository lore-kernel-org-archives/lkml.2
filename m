Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1JYUqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:46:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61606 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1JYUqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAFkjPTkbEbDp9pOg0mOrCh4BdR0SUrVj_7aJ1yfEsqRjQQcqeQ@mail.gmail.com>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
	<CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com>
	<CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com>
	<CAFkjPTkbEbDp9pOg0mOrCh4BdR0SUrVj_7aJ1yfEsqRjQQcqeQ@mail.gmail.com>
Date: Tue, 25 Oct 2011 22:46:44 +0200
X-Google-Sender-Auth: eeFLKoeOSLDaeesEzmczuFzYh0Q
Message-ID: <CAMuHMdURkdEeCELptisYT4FP5hTBwxBogA4oiZoS+rR2DoDpfw@mail.gmail.com>
Subject: Re: [GIT PULL] 9p changes fro merge window
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 22:23, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> On Tue, Oct 25, 2011 at 3:14 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>> On Tue, Oct 25, 2011 at 2:25 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Mon, Oct 24, 2011 at 6:28 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>>>
>>> (Also, I'm only seeing about half the patches mentioned in linux-next. Hmm?)
>>
>> okay.  that's weird.  I thought linux-next has been pulling from my
>> github tree (I sent an updated URL some time back).  I guess I never
>> really checked to make sure he was getting the updated files.  I'll
>> rectify this as well.
>
> okay, which linux-next tree are you looking at (and/or which patches
> are they missing)? If I look at
> /pub/scm/linux/kernel/git/next/linux-next.git on kernel.org I see all
> the patches mentioned in my pull.  Sorry in advance if I'm doing
> something stupid.

Current linux-next is next-20111025, but the previous one was next-20111014.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
