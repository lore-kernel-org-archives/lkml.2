Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1KBUaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:30:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38977 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1KBUaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:30:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAOmrzkJGhoBfqeTGROWdDXeL4HVJq2XaPJEtn0CzuNTOyCab9A@mail.gmail.com>
References: <alpine.DEB.2.00.1103201010001.13805@ayla.of.borg>
	<CAMuHMdWVchre0g6dE1j_s-+Wc3n17uifQLH6kRfJ9Q2DKfqBLQ@mail.gmail.com>
	<CAOmrzkJGhoBfqeTGROWdDXeL4HVJq2XaPJEtn0CzuNTOyCab9A@mail.gmail.com>
Date: Wed, 2 Nov 2011 21:30:10 +0100
X-Google-Sender-Auth: IwH4B0GpuJ-8MZc5DuNekP2bWf4
Message-ID: <CAMuHMdWCb-As2U1rxtaa9QWznc_yD_MWG3-5AMy5LDvp1jJUXw@mail.gmail.com>
Subject: Re: [PATCH] m68k/atari: SCC - Move Atari serial driver to staging
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitzmic@googlemail.com>,
        Alan Cox <alan@linux.intel.com>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 1, 2011 at 21:03, Michael Schmitz <schmitzmic@googlemail.com> wrote:
> On Tue, Nov 1, 2011 at 7:58 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Sun, Mar 20, 2011 at 10:11, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> Cfr. commit 4c37705877e74c02c968735c2eee0f84914cf557 ("tty: move obsolete and
>>> broken generic_serial drivers to drivers/staging/generic_serial/")
>>
>> As generic serial is gone too, cfr. commit
>> bb2a97e9ccd525dd9c3326988e8c676d15d3e12a ("Staging: delete generic_serial
>> drivers"), I'll remove the atari_scc driver. It has to be resurrected as a new
>> preferred-type-of-serial-driver-of-the-day driver anyway.
>
> Guess I've seen that coming... I had looked at other existing SCC
> drivers in the tree and Sun, SGI and Mac all had variants of it with
> different quirks. Enough to base a clean restart on. What is today's
> preferred-type-of-serial-driver-of-the-day driver framework, if I may
> ask?

Good question! Last year it was _not_ drivers/serial...

On Thu, Sep 2, 2010 at 22:12, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Mon, Aug 30, 2010 at 15:00, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Please don't convert stuff to serial_core - it's got some horrible
>> problems with adapting to the new locking model, its buffering model
>> pre-dates kfifo and all in all serial_core needs a rewrite not more users.
>
> Funny... so "fortunately" we never found time to move the m68k serial drivers
> to driver/serial/? Long live procrastination ;-)

So let's ask the experts: what will be the preferred serial driver framework
in 2012?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
