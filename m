Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2AJCMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:12:49 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:49010 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017Ab2AJCMr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:12:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6CEfSC=--Tkn2LofZuJ-TXPAMCO9qMcwovzj_k_rMiig@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
	<201109062222.p86MMlK9023363@demeter2.kernel.org>
	<CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
	<CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<CADdbW+HvKQRFJgcofZCjJrTtaPDpDhcw4UStuhyTUe1aKnD2JQ@mail.gmail.com>
	<20120108222722.GB7058@ime.usp.br>
	<CAErSpo6CEfSC=--Tkn2LofZuJ-TXPAMCO9qMcwovzj_k_rMiig@mail.gmail.com>
Date: Tue, 10 Jan 2012 00:12:47 -0200
X-Google-Sender-Auth: dWpSzavAPTp0z5c2rd-wvcZ7i9U
Message-ID: <CAOtrxKM+kS7xbGtfKRfwmPb+G=CKY+s3428KyMue=rLWDW1pwA@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Edward Donovan <edward.donovan@numble.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        bugzilla-daemon@bugzilla.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?M=C3=A1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Ram Pai <linuxram@us.ibm.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bjorn and other people.

2012/1/9 Bjorn Helgaas <bhelgaas@google.com>:
> However, I am curious about what breaks on your system when we do size
> the transparent bridge.  It seems like sizing it should *work*, even
> if it's not strictly necessary, so I wonder if this hang is telling us
> about some other PCI allocation issue we should fix.

Makes sense.

> Would you mind opening a bugzilla for this, since the current tree is broken for you,
> and attaching a log or digital photo of the hang?

I have already opened a bugzilla entry for this at:

    https://bugzilla.kernel.org/show_bug.cgi?id=41622

It contains some information already (see the attachments), but I can
always post more, of course. Just ask and I will try my best. (I will
try to post some pictures as soon as I can get back my bugzilla
password to change that bug).


Thanks,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
