Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab2AKHPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:15:16 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:43818 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991Ab2AKHPN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:15:13 -0500
MIME-Version: 1.0
In-Reply-To: <CADdbW+Eq=5U2smt=QgYiEKf2amy=xd_ZdpBZ9oLD3au7KfHgNg@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
	<201109062222.p86MMlK9023363@demeter2.kernel.org>
	<CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
	<CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<20120108221342.GA7058@ime.usp.br>
	<CADdbW+Eq=5U2smt=QgYiEKf2amy=xd_ZdpBZ9oLD3au7KfHgNg@mail.gmail.com>
Date: Wed, 11 Jan 2012 05:15:12 -0200
X-Google-Sender-Auth: V-jJJWzL-dttANELMC4hm5Ru09I
Message-ID: <CAOtrxKNGGsfwEpduF4R_G-sYgVjeeTDFmbhR0ra+ignY05fy6Q@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Edward Donovan <ed@numble.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?M=C3=A1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Edward.

2012/1/10 Edward Donovan <ed@numble.net>:
> I'm glad to see you're getting help from a lot of skilled people, here.

This is great. I'm keeping mom in CC and she is pleasantly surprised
that her case got attention from developers. She wasn't expecting one
single case to be treated seriously by important people (in her
words---and mine too).

>> It does look similar, but not quite the same. And, yes, my main desktop (the
>> one that I'm using right now) was affected by Edward's commit, which, BTW,
>> has my Reported-and-tested-by.
>
> The one area I have experience with is the IRQ regression you cite in
> 41132.  I was bitten by the regressions in spurious IRQ handling, like
> you, and this has been my first trip inside the kernel.  The patches I
> sent are the sum of my kernel wisdom to date, and I don't want to
> impersonate an experienced developer, even by accident. :)

Ooops. Sorry I listed two issues from different computers (yes, I am
seeing many issues with the computers that I have at my disposal). The
ones that I should have had listed relevant to this notebook are:

* https://bugzilla.kernel.org/show_bug.cgi?id=41622
* https://bugzilla.kernel.org/show_bug.cgi?id=41722

Issue

* https://bugzilla.kernel.org/show_bug.cgi?id=41132

should not have been mentioned here. Too many issues and I got confused. Sorry.

> Is there an IRQ disabled, "nobody cared", problem, even with the
> newest kernels?
>
> If you have info on IRQ problems, I can look at it, hopefully soon.
> Right now, it might make sense to let this PCI effort roll forward,
> before opening a second front, but I can't say that for sure.  I
> certainly hope we can make your mom's notebook a happy Linux box.

Well, as you mention, yes, I have one case of "nobody cared" in this
very desktop (this one I didn't file on bugzilla) that I am using
right now (and I have to boot with irqpoll), but I guess that this is
another issue entirely. If you could help me with this "nobody cared"
thing, then I will be glad to provide copious amounts of data. :)


Thanks,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
