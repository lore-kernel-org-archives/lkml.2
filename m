Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab2LHKwm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 05:52:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43080 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab2LHKwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 05:52:40 -0500
Date: Sat, 8 Dec 2012 11:52:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121208105234.GA14569@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andreas Mohr <andi@lisas.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
 <20121205142935.GA12119@liondog.tnic>
 <20121205152756.5afec12c@pyramind.ukuu.org.uk>
 <20121205153121.GA28556@liondog.tnic>
 <20121205133853.770451ca.akpm@linux-foundation.org>
 <20121207165218.GA13421@rhlx01.hs-esslingen.de>
 <20121207174405.GF27523@liondog.tnic>
 <20121208073634.GA30690@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121208073634.GA30690@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2012 at 08:36:34AM +0100, Andreas Mohr wrote:
> And that demand actually applies to both the '@' change (questionable)
> and the much less disputed (obviously correct) wrong conditional
> fixup, since both introduce a notable change (either large, or
> possibly improper) in behaviour.

Well, I think Alan's fix is obviously correct and doesn't necessarily
need confirmation. But it will have ~3 months verification time in 3.8,
just in case.

> > So the actual practical question turns into: do you have such
> > hardware to verify your or anyone else's fix on?
>
> Not the ALS100 (only ALS4000 here). I possibly have some other
> ISA hardware, but probably none which contains '@' data in their
> PnP id struct. The driver for the well-known case of ISDN PnP
> cards does not seem to contain it. However ISTR that CMI8330 was
> quite widespread (did I have one? Do I??). For identification, see
> http://www.yjfy.com/C/C-Media/soundchipset/CMI8330A.htm
>
> I'm afraid I should get an old system back up and running, exactly for
> such validation work cases (and perhaps so should a select few other
> developers, too).
>
> BTW, "my" fix? I thought that everybody had come to the conclusion by
> now that I merely pointed out (in no uncertain terms to boot) that
> something was broken :)

Ok, here's the deal: we can blubber about fixing bugs in the kernel and
whether it needs this and that forever, but at the end of the day, Linux
is scratching an itch. That's it. There are no contracts, affirmations
or whatever. IOW, if it is not itching you strong enough, you won't
scratch it.

All I'm saying is, there are bugs and bugs. If this is a bug in a piece
of hardware which no one uses anymore and it might be violating the spec
or not, whatever, who cares..., but we can't verify that anymore, then
we leave it as is. There's absolutely no reason to touch this code and
so we'll let it die a peaceful death.

Now, if your box doesn't boot or something else annoys you strong enough
(the itch), then you can try fixing it (the scratch), or involve someone
more knowledgeable if you cannot do it yourself.

In any case, if you decide to fix anything though, you better do it
right. Thus the requirement to verify the fix on a real hardware.

So to answer your initial rant: yes, like any other non-trivial piece
of software, there are bugs in the kernel too. And yes, we always try
addressing the most important ones as fast as possible. And I'm sure
you know the kernel's track record of fixing bugs in a lightning fast
manner.

The other, not-so-important, not-so-critical bugs get "delayed"
sometimes. :-)

That's the whole deal.

-- 
Regards/Gruss,
    Boris.
