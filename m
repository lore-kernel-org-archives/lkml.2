Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0ICKCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:02:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36440 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0ICKC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:02:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HQU9KA0xcbwab0iIzdpU9/xt55sAvCgsbf5ICC7Jy8V8QAvvPQzUaACtGVd1Eir2qX
         r9YpUgCs+y5w/o+pB+5X7EshtTLOKPxO5AYezLCJcF563pGmGyjYmMmky/8gSZ+NuWAt
         gPyCxs49EUR+Bnq7eFEAMtzFKJl0Hd1o71HHc=
MIME-Version: 1.0
In-Reply-To: <7877.1283507577@redhat.com>
References: <m3vd6nmd68.fsf@hase.home>
	<19747.1283422807@redhat.com>
	<20100902102158.19806.14133.stgit@warthog.procyon.org.uk>
	<m38w3kns4r.fsf@hase.home>
	<AANLkTikwax-Jb60jT5_TOL=Zkwbgh8FwMk78ncm1dN-P@mail.gmail.com>
	<3048.1283505520@redhat.com>
	<4C80C068.1010302@snapgear.com>
	<AANLkTikBLCg_FUwGGiajw3+dgCe6y0s0a1yMs8=A2oCR@mail.gmail.com>
	<7877.1283507577@redhat.com>
Date: Fri, 3 Sep 2010 12:02:28 +0200
X-Google-Sender-Auth: StmvETts253UZCa7-LO9_Dcnshs
Message-ID: <AANLkTi=1vPD-9iU7EszKwx1PV=Qay_d4dt_pT75sKj2a@mail.gmail.com>
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select
 m68knommu contributions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>, Andreas Schwab <schwab@redhat.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 3, 2010 at 11:52, David Howells <dhowells@redhat.com> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
>> > Not sure about m68k but m68knommu targets already setup
>> > appropriate -mcpu flags for its various supported CPU types.
>>
>> Same for m68k.
>
> It doesn't seem to:
>
>        warthog>grep -r mcpu arch/m68k
>        warthog1>grep -r mtune arch/m68k
>        warthog1>

Sorry, we're still using e.g. -m68040 instead of the -mcpu/-mtune variants.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
