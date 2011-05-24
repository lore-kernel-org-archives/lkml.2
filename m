Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab1EXR3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:29:51 -0400
Received: from seven.medozas.de ([188.40.89.202]:58248 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab1EXR3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:29:49 -0400
Date: Tue, 24 May 2011 19:29:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jacek Luczak <difrost.kernel@gmail.com>, linux-arch@vger.kernel.org,
        "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: (Short?) merge window reminder
In-Reply-To: <20110524154626.GD30117@linux-mips.org>
Message-ID: <alpine.LNX.2.01.1105241927570.1099@frira.zrqbmnf.qr>
References: <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com> <20110523231721.GM10009@thunk.org> <4DDAEC68.30803@zytor.com> <BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com> <alpine.LNX.2.01.1105241409280.15351@frira.zrqbmnf.qr>
 <BANLkTimCXVdVa6KLRG8GJR1gJY=7_5SkOA@mail.gmail.com> <alpine.LNX.2.01.1105241500410.23085@frira.zrqbmnf.qr> <BANLkTinNK+9XijCN0YGXyvLQ8_npPTG2cQ@mail.gmail.com> <20110524154348.27ba649d@lxorguk.ukuu.org.uk> <20110524154626.GD30117@linux-mips.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2011-05-24 17:46, Ralf Baechle wrote:
>On Tue, May 24, 2011 at 03:43:48PM +0100, Alan Cox wrote:
>
>> Can we drop most of MCA, EISA and ISA bus if we are going to have a big
>> version change ? A driver spring clean is much overdue and it's all in
>> git in case someone wishes to sneak out at midnight and bring some crawly
>> horror back from the dead.
>
>Dunno about MCA but I doubt we can kill all of (E)ISA. i8253, i8259 and a
>few others still refuse hard to die.  
>
>Is it worth to setup a system to track success / failure reports for
>drivers and ditch drivers once there are no success reports for a driver
>for too long?  It may not be a good idea - people tend not report success
>much more rarely than failure.
>
>(On that matter, I wonder if there are 5.25" USB floppy drives ...)

If there were, they would appear as Mass Storage devices (at least
the 3.5" USB floppy gadgets do), and as such, don't depend on ISA
or the classic floppy driver at all.
