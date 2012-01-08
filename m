Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab2AHAzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 19:55:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57056 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2AHAzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 19:55:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
	<201109062222.p86MMlK9023363@demeter2.kernel.org>
	<CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
Date: Sat, 7 Jan 2012 22:55:53 -0200
Message-ID: <CAF3stZzkxaazf+ttutFrX18nxt5VEiSABm3atnzJ76e2qt2pQg@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: =?ISO-8859-1?Q?M=E1rcia_Brito?= <mcbrito@gmail.com>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear sirs
I greatly appreciate the interest in helping me get my notebook using linux
I was surprised by the commitment of you to help
forever grateful
Marcia

Em 6 de janeiro de 2012 23:31, Rogério Brito <rbrito@ime.usp.br> escreveu:
> Hi, Bjorn and others,
>
> Now that bugzilla is up, I think that I can resume testing things on
> that problematic notebook that I mentioned in earlier e-mails, so that
> mom (in CC) can use her notebook with Linux.
>
> For the record, *some* description of the problem is at:
>
> * https://bugzilla.kernel.org/show_bug.cgi?id=41132
> * https://bugzilla.kernel.org/show_bug.cgi?id=41722
>
> The first one is a regression that I bisected, while the second one
> seems to be a bit harder to understand for a layman like me.
>
> Of couse, I can summarize what I found and what I didn't.
>
> Sorry for the top-posting, but it is here to keep the context of the
> previous message.
>
> Thanks,
> Rogério Brito.
>
> On Tue, Sep 6, 2011 at 19:22,  <bugzilla-daemon@bugzilla.kernel.org> wrote:
>>
>>
>>
>>
>>
>> --- Comment #15 from Rogério Brito <rbrito@ime.usp.br>  2011-09-06 22:22:44 ---
>> Dear Bjorn,
>>
>> Sorry for not responding promptly but I had some family members with health
>> problems. Things are settling right now and I think that I can be faster now.
>>
>> (In reply to comment #14)
>>> So it looks like 2.4.27 doesn't even try to enable ACPI mode, and 2.6.8 hangs
>>> the same way as 3.1.0-rc3.
>>
>> Yes, exactly.
>>
>>> Can you try 2.6.28?  If that doesn't boot, try the Ubuntu 9.04 kernel, which
>>> was reported to boot on your machine/BIOS.
>>
>> Unfortunately, I tried to boot with that version of the Ubuntu live CD and it
>> crashed the same way. I may try it once again, paying more attention if it
>> behaves differently in any kind of way, though.
>>
>> Oh, talking about PCI and ACPI failing, could you take a look at issue #41132
>> to see if you can help with another machine that stopped working after a commit
>> that I bisected?
>>
>>
>> Thanks,
>>
>> Rogério Brito.
>>
>> --
>> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
>> ------- You are receiving this mail because: -------
>> You are on the CC list for the bug.
>
>
>
> --
> Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
> http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
> DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
