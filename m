Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab2AMMAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 07:00:30 -0500
Received: from a2-smtpout1.uol.com.br ([200.147.33.239]:34812 "EHLO
	smtps.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753081Ab2AMMA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 07:00:28 -0500
X-UOL-SMTP: SMTPS25
Date: Fri, 13 Jan 2012 09:59:46 -0200
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?utf-8?Q?M=C3=A1rcia?= Coutinho de Brito <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
Message-ID: <20120113115946.GA10615@ime.usp.br>
References: <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
 <20120108221342.GA7058@ime.usp.br>
 <CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
 <20120109112207.7f993845@jbarnes-desktop>
 <CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
 <CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
 <CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
 <CAE9FiQWg8k-_eHH-Erwn+iZgs-rDfPcSc7uPcF_h+1+mXVEVXQ@mail.gmail.com>
 <CAOtrxKOZ1yuWaAYxjPLE2obwTkCfRytRFyQc3VuK9JmJLYVrqw@mail.gmail.com>
 <CAE9FiQXCJobMuFWbyoWQpVup_pvKMuGpu7eotF0EJAx2_Ee7OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXCJobMuFWbyoWQpVup_pvKMuGpu7eotF0EJAx2_Ee7OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SIG5: b186cbbbac82ea032215e64a5186bf83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Yinghai,

On Jan 11 2012, Yinghai Lu wrote:
> On Tue, Jan 10, 2012 at 11:04 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
> > On Tue, Jan 10, 2012 at 03:07, Yinghai Lu <yinghai@kernel.org> wrote:
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> >> for-pci2
> >>
> >> also please boot with "debug ignore_loglevel"
> >
> > Grabbing it right now. Will report it after I get some sleep (5AM here).
> 
> please try attached patch, it will fix one bios wrong setting.

Should I use this patch agains which tree?

Right now, I have Linus's tree, yours (cited above) and I am, up to now,
I had been compiling everything from Linus's v3.2 tag: both a vanilla
kernel, as asked by Bjorn and with the patch that I mentioned to Linus ("the
one that makes things boot").

If it applies (and newer kernels don't have things which your patch needs),
I will keep working with Linus's v3.2 tag.

When I compiled from your branch for-pci2 from linux-yinghai.git (without
any extra patches), it *did* boot, but noticed one thing weird: using htop
and in single user mode, it reported 100% of CPU in use. With regular top, a
more fine grained output revealed that no processes were using the CPU, but
that almost all of the time was spent in kernel mode.

Anyway, as you asked, I put the log of what I see at

    http://www.ime.usp.br/~rbrito/linux/clevo/2012-01-13-0951-yanghai-for-pci2-branch/

> >> BTW, did you try boot with "pci=use_crs" and not with "acpi=off" ?
> >
> > I tried, but I got a hang (both with Linux---many versions---and with
> > FreeBSD). With Linux I get:
> >
> >  http://www.ime.usp.br/~rbrito/linux/clevo/boot-without-acpi-off.jpg
> >
> 
> need to work on that later.

Thanks for your (everybody else's) kindness/helpfulness with these multiple
issues.


Thanks,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
