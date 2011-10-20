Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1JTPDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:03:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64792 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1JTPC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:02:58 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1110202347320.2696@nippy.intranet>
References: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdWOhKcoDoyTnKJzruZ=gpV5uKNFpXnGCkrac7oEkCihJw@mail.gmail.com>
	<alpine.LNX.2.00.1110202347320.2696@nippy.intranet>
Date: Thu, 20 Oct 2011 17:02:57 +0200
X-Google-Sender-Auth: 8ojlD-Y2yFjo6inlkOCO3OXrin4
Message-ID: <CAMuHMdVMp65XzV2zu7V8sgwsniCAxD7NDDnHSvp5gO-8g1ovHg@mail.gmail.com>
Subject: Re: [PATCH 00/28 v6] m68k: Convert to genirq
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 15:40, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Thu, 20 Oct 2011, Geert Uytterhoeven wrote:
>
>> > There are some known issues with drivers, which Finn and Michael are
>> > looking into.
>>
>> Any fixes I still have to apply?
>
> I did some further testing on Baboon and OSS hardware etc. and I didn't
> find any new regressions to fix.
>
> There is a cleanup patch though --
> http://article.gmane.org/gmane.linux.ports.m68k/2726

OK, I'll add it.

>> Updated, on top of m68k master (which is at v3.1-rc10 now).
>> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=refs/heads/m68k-genirq
>>
>> If noone objects, I'd like to add this to the m68k master and for-3.2
>> branches.
>
> Sounds good. The mac_esp fix I sent is already in linux-next.

Thanks for reminding me I still have to apply that one :-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
