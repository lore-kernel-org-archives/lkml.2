Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab1JHP2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 11:28:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38103 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1JHP2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 11:28:41 -0400
MIME-Version: 1.0
In-Reply-To: <58779.1318084612@turing-police.cc.vt.edu>
References: <4E8655CD.90107@zytor.com>
	<201110020304.28288.rjw@sisk.pl>
	<4E87B885.50005@zytor.com>
	<201110021354.57995.rjw@sisk.pl>
	<4E88A537.4010008@zytor.com>
	<20111003093239.GB25136@localhost.pp.htv.fi>
	<y0mobxyjazi.fsf@fche.csb>
	<20111003180441.GD3072@localhost.pp.htv.fi>
	<34045.1317760188@turing-police.cc.vt.edu>
	<1317916702.19519.1.camel@constitution.bos.jonmasters.org>
	<14191.1317930659@turing-police.cc.vt.edu>
	<m34nzlbwbi.fsf@intrepid.localdomain>
	<15324.1318004954@turing-police.cc.vt.edu>
	<1318050133.19519.184.camel@constitution.bos.jonmasters.org>
	<58779.1318084612@turing-police.cc.vt.edu>
Date: Sat, 8 Oct 2011 17:28:41 +0200
X-Google-Sender-Auth: aBgSwJSS0MVzWjYnHEcC25c2L3E
Message-ID: <CAMuHMdV8bW_N9dSo0-4qYyhj7khTNfSCj=vx+PCRZGE1Krs38A@mail.gmail.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Valdis.Kletnieks@vt.edu
Cc: Jon Masters <jonathan@jonmasters.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Adrian Bunk <bunk@stusta.de>, "Frank Ch. Eigler" <fche@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 8, 2011 at 16:36, <Valdis.Kletnieks@vt.edu> wrote:
> However, you have to remember that *all* real-life identity proofs are to
> some degree probabalistic.  How do you know your lawyer is a *real* lawyer
> and not somebody with a fake degree?  Mostly because the other lawers
> in town and the judges are convinced he's a lawyer too.  Same goes for
> your doctor - how do you know he *really* went to med school?  Even calling
> the med school and verifying only proves that somebody with that name went
> there that year.  And yes, every year we hear about a few fake lawyers and
> doctors on the news.  But society seems to muddle along just fine anyhow.

In real life, it's also called the web of trust. How do you prove to a foreign
government that you're (a) not a convicted criminal and (b) in a healthy state?
  - You ask your doctor to write a signed declaration,
  - You go to the ministry of healthcare, which checks the signature
and registration
    number of the doctor, and adds a signature and stamp to the document,
  - You go to the police station, to get a good standing certificate, signed by
    the mayor,
  - You go to the ministry of foreign affairs, which checks the
signatures and stamps
    of the ministry of healthcare officer and of the mayor, and adds
an apostille
    to your documents,
  - The foreign government verifies the apostille from your ministry of foreign
    affairs.

Very similar to PGP ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
