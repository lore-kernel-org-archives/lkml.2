Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab2AGET1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 23:19:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59931 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab2AGET0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 23:19:26 -0500
MIME-Version: 1.0
X-Originating-IP: [71.233.110.244]
In-Reply-To: <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/> <201109062222.p86MMlK9023363@demeter2.kernel.org>
 <CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com> <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
From: Edward Donovan <edward.donovan@numble.net>
Date: Fri, 6 Jan 2012 23:19:04 -0500
X-Google-Sender-Auth: 7MA45h4eIwCZCRpJc4KlRNaFJD8
Message-ID: <CADdbW+HvKQRFJgcofZCjJrTtaPDpDhcw4UStuhyTUe1aKnD2JQ@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        bugzilla-daemon@bugzilla.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 8:50 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> 2012/1/6 Rogério Brito <rbrito@ime.usp.br>:
>>
>> For the record, *some* description of the problem is at:
>>
>> * https://bugzilla.kernel.org/show_bug.cgi?id=41132
>
> This one looks very much like the thing that Edward Donovan fixed
> fairly recently in commit 52553ddffad7 ("genirq: fix regression in
> irqfixup, irqpoll")
>
> So that should be fixed in 3.2 (and it's marked for stable, so I think
> it's in the latest stable kernels too)

Yessir, as of 3.0.13 and 3.1.5.  Rogério - for all the users I've
heard from, the 2.6.39 IRQ regressions are fixed now.  I'll be
interested to know if any IRQ handled by 2.6.38 isn't handled now, but
I expect it will be.  I'm sorry if that isn't enough for this laptop,
though -

Ed
