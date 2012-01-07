Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab2AGBui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 20:50:38 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57460 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343Ab2AGBud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 20:50:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/> <201109062222.p86MMlK9023363@demeter2.kernel.org>
 <CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jan 2012 17:50:11 -0800
X-Google-Sender-Auth: e4y5eVBx1JzfuwAhemTSEsIex78
Message-ID: <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/6 Rogério Brito <rbrito@ime.usp.br>:
>
> For the record, *some* description of the problem is at:
>
> * https://bugzilla.kernel.org/show_bug.cgi?id=41132

This one looks very much like the thing that Edward Donovan fixed
fairly recently in commit 52553ddffad7 ("genirq: fix regression in
irqfixup, irqpoll")

So that should be fixed in 3.2 (and it's marked for stable, so I think
it's in the latest stable kernels too)

> * https://bugzilla.kernel.org/show_bug.cgi?id=41722

That, however, looks totally insane. I don't even have a clue where to
begin. I take it that it works with "acpi=off", and don't have a clue
about what might go wrong with ACPI enabled.

                       Linus
