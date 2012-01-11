Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2AKHFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:05:49 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64721 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636Ab2AKHFo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:05:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5RwkriMA=2H0UR7tA9LyMi__QaAm-16kYSKpiK3oLVvw@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
	<201109062222.p86MMlK9023363@demeter2.kernel.org>
	<CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
	<CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<20120108221342.GA7058@ime.usp.br>
	<CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
	<20120109112207.7f993845@jbarnes-desktop>
	<CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
	<CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
	<CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
	<CAErSpo5RwkriMA=2H0UR7tA9LyMi__QaAm-16kYSKpiK3oLVvw@mail.gmail.com>
Date: Wed, 11 Jan 2012 05:05:44 -0200
X-Google-Sender-Auth: kkAMrzttHdjZ3WODZLx2GdD07U0
Message-ID: <CAOtrxKObbRSHsadjgJse1MwbCTjcaf6o1gp2nLVseJGEDnwuqQ@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?M=C3=A1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bjorn.

2012/1/10 Bjorn Helgaas <bhelgaas@google.com>:
> On Mon, Jan 9, 2012 at 7:41 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
>
>> Please, note that this boot log was taken with the patch that I
>> e-mailed earlier (i.e., the one that makes things work). If you want
>> me to send a log with a vanilla kernel, just let me know and I will
>> grab more information.
>
> I'd definitely be interested in a log with a vanilla kernel.

Sure, here you go:

    http://www.ime.usp.br/~rbrito/linux/clevo/boot-with-vanilla-3.2.m4v


Thanks for any insight,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
