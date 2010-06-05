Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab0FEUCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:02:01 -0400
Received: from ist.d-labs.de ([213.239.218.44]:42368 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab0FEUB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:01:59 -0400
Date: Sat, 5 Jun 2010 22:01:43 +0200
From: Florian Mickler <florian@mickler.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100605220143.08774900@schatten.dmk.lab>
In-Reply-To: <AANLkTikna-Vs_phy2VrJs0I8gIsdSmwuxTJ67gQ_2oTt@mail.gmail.com>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<201005302202.39511.rjw@sisk.pl>
	<AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
	<201005312347.24251.rjw@sisk.pl>
	<AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
	<alpine.LFD.2.00.1006011411200.2933@localhost.localdomain>
	<AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
	<alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
	<AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
	<1275471561.27810.30865.camel@twins>
	<AANLkTilLmAb2c9fQwuguzWtjcHfuTZvPUTbUx7vuwFI6@mail.gmail.com>
	<AANLkTikna-Vs_phy2VrJs0I8gIsdSmwuxTJ67gQ_2oTt@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010 20:44:24 +0300
Felipe Contreras <felipe.contreras@gmail.com> wrote:

> 2010/6/2 Arve Hjønnevåg <arve@android.com>:
> > 2010/6/2 Peter Zijlstra <peterz@infradead.org>:
> >> (and please don't mention @#$@ up x86 ACPI again, Intel knows, they're
> >> fixing it, get over it already).
> >>
> >
> > I don't think it is realistic to drop support for all existing hardware.
> 
> We are talking about mainline here, there's no support for suspend
> blockers, so nothing is dropped.
> 
> In the mind of everybody, suspend blockers is for opportunistic
> suspend, which only makes sense on sensible hw (not current x86). So
> in the mind of everybody, x86 should be out of scope for the analysis
> of suspend blockers.
> 
> Are you seriously suggesting that one of the strong arguments in favor
> of suspend blockers is x86 usage (nobody agrees)? If not, then drop
> it.

I think they have an advantage over the
30-minute-screensaver-then-suspend that current desktops do. Because
you can define what keeps the system up. I.e. the
screensaver/powermanager is not limited to keyboard- and
mouse-inactivity.

> If I enable suspend blockers on my laptop, I have to modify my
> user-space. Otherwise my system will behave horribly.
> 

In the simplest case you have a shell script which takes a suspend
blocker and reads from stdinput. When you write "mem" to it, it
releases the suspend blocker and acquires it back again. Voila, forced
suspend reimplemented on top of opportunistic suspend.

That wasn't hard, was it? 

Cheers,
Flo
 

