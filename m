Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298Ab1FXGIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 02:08:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53196 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761258Ab1FXGII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 02:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=h6YxSLdUrW0hegW4nUvxEIcJhPyztxMwrpLBAAT1GwUvwUFHevLwyl7KDJsU7AQvWA
         jgxUdWBtmWM/xDCwClZtjlSQScFLMMI46glRvfZM2rngDsHxDXQaxdN8X63hc1BoGuIs
         cYHGYFUzZur1EWdDTR+jLkjNAPudZHO21aV4o=
MIME-Version: 1.0
In-Reply-To: <20110623212736.74bea79a.sfr@canb.auug.org.au>
References: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
	<BANLkTikBDVR=S5J-=Kjq1QW3OU64WzHYRg@mail.gmail.com>
	<20110618183029.822f4d82.sfr@canb.auug.org.au>
	<20110623212736.74bea79a.sfr@canb.auug.org.au>
Date: Fri, 24 Jun 2011 08:08:06 +0200
X-Google-Sender-Auth: 3mY5bSnysMR0A4HNriuesp_1ZYE
Message-ID: <BANLkTimoWrwPNNYrLFN-_gyPnvSCEa9ksA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Jun 23, 2011 at 13:27, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Sat, 18 Jun 2011 18:30:29 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> On Wed, 15 Jun 2011 11:19:48 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > Would it be possible to build with `make -k', so it continues in case
>> > of an error, and
>> > tries to build as much as possible?
>> > Yes, I know this may increase build time considerably, but in an ideal
>> > world, there
>> > are no compile errors and everything is built anyway ;-)
>>
>> Done (I think - it required very simple changes to a Python script and I
>> only do "monkey see, monkey do" Python programming :-))
>
> I also made the mistake of fixing things so that the automatic "git
> bisect for build failures" would work.  That was taking much too much
> time (over 4 hours for one build), so I have turned it off.  Hopefully,
> the builds will now run in a more reasonable time frame.

Yeah, I noticed it. There are still no results for 3.0-rc4...

Probably you should only bisect for configs that where "green" recently.
And hope people fix reported regressions the-next-day-as-we-speak :-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
