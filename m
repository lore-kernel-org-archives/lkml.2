Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1H0Sze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:55:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58386 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1H0SzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:55:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110826213641.GA8671@www5.open-std.org>
References: <20110809181534.GR10171@einval.com>
	<20110823161134.GV3053@linaro.org>
	<efc47c3039402c1507d76f381a790115@mail.shatteredsilicon.net>
	<CAPweEDwkVWH=r_moJj1_CKLxRUkkbBgHenZhwi8CzY9z3BO-Cw@mail.gmail.com>
	<CADkCAuuaH5k2duuvUdmj1j9=6oaCKORN-NJGg4gt2ovEshHYmw@mail.gmail.com>
	<alpine.DEB.2.02.1108241648360.29431@asgard.lang.hm>
	<CADkCAut2sMMKcCLiG0g+Rwt5z4dXJgRZYyvUAzCQVTQQMPFJmA@mail.gmail.com>
	<20110826163502.GB23469@n2100.arm.linux.org.uk>
	<CAPweEDxJO0=tFOHhiiiDvucQYZ-0EJZZbsqWwc7BHrZQ2=a5sQ@mail.gmail.com>
	<20110826213641.GA8671@www5.open-std.org>
Date: Sat, 27 Aug 2011 19:55:22 +0100
X-Google-Sender-Auth: 6Bt228RrajshWhus1D5LLfplG_E
Message-ID: <CAPweEDwPD_v454sDtPqZNmpRs+gw4U9KQUHncuJ32gpd8uedYg@mail.gmail.com>
Subject: Re: [lsb-discuss] [fedora-arm] ARM summit at Plumbers 2011
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: keld@keldix.com, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        david@lang.hm, cross-distro@lists.linaro.org,
        Bill Gatliff <bgat@billgatliff.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bruce Perens <bruce@perens.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        torvalds@linux-foundation.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 10:36 PM,  <keld@keldix.com> wrote:
> I would relly like the dscussion to go on widely as it is now.
> Otherwise I would probably not follow this interesting discussion.

 keld, the encouragement is appreciated, and i do follow the reasoning
(which is that, given that gnu/linux distros are at such an
interesting threshold point, there's simply been no need for such a
large cross-posting before).

 but, i have to keep my word, and i said i wouldn't interrupt people
on such a large scale, preferring instead that those people who are
*actively* interested participate.  if, however, *you* - or anybody
else feels that this topic still needs to reach a wider audience, in
order to help things reach critical mass, please do actively bring it
to their attention.

 i have another write-up, done today, which brings together both the
software and this time hardware strategic design concepts that i
believe will help put control firmly back into the hands of Free
Software Developers:

 http://lkcl.net/linux/modular.computing.architecture.html

 linus: if you're happiest doing device driver development, then for
goodness sake stop complaining about how bad ARM development is going,
and get involved in a real-world ARM embedded project.  not just _any_
old ARM embedded project, but a "Meta-"Project that would help future
Linux Kernel Development through large-scale code re-use.  and,
through that, you'd actually really _really_ begin to appreciate why
Russell's getting so pissed off.

 russell: i realise that this is going to sound strange, but if you're
actually _happy_ continuing to get pissed off and disillusioned with
being nothing more than a Git Patch Conflict Manager, please feel free
to completely ignore the entirety of this message _and_ the link
above.  you _can_ tell people to piss off: you're perfectly within
your rights as a Free Software Developer to do so.  take a busman's
holiday: lead by example and help spearhead this project.

everyone else: if you feel that you want to see happen a project to
put the kind of hardware that is desirable *to you* into *your* hands
(because it was, like the OpenPandora, developed with open involvement
from its community, rather than developed in secret and presented as a
fait-accomplit), then make yourself known - especially to those people
whom *you* believe should spearhead the project.

also it has to be said that if you believe that there is someone else
whom you feel would be more suitable to spearhead the project, please
do say so - and help campaign to bring them in.

OpenPandora was - is - a *success*, despite vast sums of money - 4,000
preorderers *up-front* money held in escrow - being spent on casework
and on making mistakes such as paying an ex-TI employee $50k to fail
to get the 1251 WIFI module PCB area right.

learning from these mistakes, it *is* possible to drastically cut the
cost of hardware development, by leveraging existing designs and
adapting them.

now, it has to be said that if, after hitting such a large audience i
_still_ don't get any traction on this project, then that's it, i'm
"dun spammin".  as an experienced Free Software Developer with
ARM-embedded HTC Reverse-Engineering experience, i _will_ continue as
best i can to play "guess what kind of hardware that Free Software
Developers would want", and i _will_ continue to fit this into ongoing
negotiations with PCB Factories in China, with whom i have been
working hard to get them to respect and understand the importance of
GPL Compliance *up-front*.

a translation of that paragraph is: you, The Free Software Community,
are being presented with an OpenPandora-like opportunity, to leverage
negotiations for the production of mass-volume products, to actually
really REALLY get that decent ARM Laptop with a pre-loaded GNU/Linux
Distro of YOUR choice (*), or that decent Desktop PC with a pre-loaded
GNU/Linux Distro of your choice - whatever it is, you need to speak up
NOW.

and the reason you need to speak up right now is because then i can
justify going to the factory to say "yes, there are NN people who want
this", and it goes from there.

but, of course, it goes without saying, that if you would prefer that
there be other figureheads leading this project, for them to choose
appropriate factories and to negotiate them into GPL compliance,
please feel free to do so, and take this opportunity to speak up and
to campaign for such figureheads to back this project.

i don't mind that happening: all i want is my damn 1280x800 12in (and
importantly $160) ARM-based laptop, damnit :)

l.

(*) instead of a laptop with only 512mb of RAM.  or a 1024x600 LCD
(Toshiba AC100, Genesi Efika, AlwaysInnovating, etc.).  or being
vapourware (too numerous and pointless to enumerate).  or being an R&D
model which was so expensive to develop that no retailer could touch
it (e.g. the Pegatron Netbook).  or being effectively closed-source
(almost every Android product in existence).  or GPL-violating (almost
every Android Tablet in existence).  or requiring reverse-engineering
(the Toshiba AC100).
