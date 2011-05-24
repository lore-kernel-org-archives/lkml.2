Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1EXPqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:46:35 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59355 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752104Ab1EXPqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:46:33 -0400
Date: Tue, 24 May 2011 16:46:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
        Jan Engelhardt <jengelh@medozas.de>, linux-arch@vger.kernel.org,
        "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: (Short?) merge window reminder
Message-ID: <20110524154626.GD30117@linux-mips.org>
References: <20110523192056.GC23629@elte.hu>
 <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
 <20110523231721.GM10009@thunk.org>
 <4DDAEC68.30803@zytor.com>
 <BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com>
 <alpine.LNX.2.01.1105241409280.15351@frira.zrqbmnf.qr>
 <BANLkTimCXVdVa6KLRG8GJR1gJY=7_5SkOA@mail.gmail.com>
 <alpine.LNX.2.01.1105241500410.23085@frira.zrqbmnf.qr>
 <BANLkTinNK+9XijCN0YGXyvLQ8_npPTG2cQ@mail.gmail.com>
 <20110524154348.27ba649d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524154348.27ba649d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 03:43:48PM +0100, Alan Cox wrote:

> Can we drop most of MCA, EISA and ISA bus if we are going to have a big
> version change ? A driver spring clean is much overdue and it's all in
> git in case someone wishes to sneak out at midnight and bring some crawly
> horror back from the dead.

Dunno about MCA but I doubt we can kill all of (E)ISA. i8253, i8259 and a
few others still refuse hard to die.  

Is it worth to setup a system to track success / failure reports for
drivers and ditch drivers once there are no success reports for a driver
for too long?  It may not be a good idea - people tend not report success
much more rarely than failure.

(On that matter, I wonder if there are 5.25" USB floppy drives ...)

  Ralf
