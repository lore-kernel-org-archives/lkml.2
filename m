Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab2AKKpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:45:50 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40764 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab2AKKps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:45:48 -0500
Date: Wed, 11 Jan 2012 18:45:38 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?M=E1rcia?= Coutinho de Brito 
	<mcbrito@gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
Message-ID: <20120111104538.GD7380@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
 <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
 <20120108221342.GA7058@ime.usp.br>
 <CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
 <20120109112207.7f993845@jbarnes-desktop>
 <CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
 <CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
 <CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
 <CAErSpo5RwkriMA=2H0UR7tA9LyMi__QaAm-16kYSKpiK3oLVvw@mail.gmail.com>
 <CAOtrxKObbRSHsadjgJse1MwbCTjcaf6o1gp2nLVseJGEDnwuqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOtrxKObbRSHsadjgJse1MwbCTjcaf6o1gp2nLVseJGEDnwuqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12011110-6078-0000-0000-00000696BFD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 05:05:44AM -0200, Rogério Brito wrote:
> Hi, Bjorn.
> 
> 2012/1/10 Bjorn Helgaas <bhelgaas@google.com>:
> > On Mon, Jan 9, 2012 at 7:41 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
> >
> >> Please, note that this boot log was taken with the patch that I
> >> e-mailed earlier (i.e., the one that makes things work). If you want
> >> me to send a log with a vanilla kernel, just let me know and I will
> >> grab more information.
> >
> > I'd definitely be interested in a log with a vanilla kernel.
> 
> Sure, here you go:
> 
>     http://www.ime.usp.br/~rbrito/linux/clevo/boot-with-vanilla-3.2.m4v
> 

I cannot tell what exactly is the problem, but looks like the transparent
bridge gets assigned a positive-decoded address, which seems to create some
conflict later somehow..

RP

