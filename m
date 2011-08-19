Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1HSLxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:53:36 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39979 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab1HSLxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:53:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAPweEDxwyB6BekTc8PqyVBeAkK3oMv1ZQ_ZX=zuta10OdCy5Kw@mail.gmail.com>
References: <CAPweEDxwyB6BekTc8PqyVBeAkK3oMv1ZQ_ZX=zuta10OdCy5Kw@mail.gmail.com>
Date: Fri, 19 Aug 2011 12:53:30 +0100
Message-ID: <CAPweEDwvTcFFrsWhjhaRgC+1YbwGthxQrd40mw9H6aLgXzJ1Jg@mail.gmail.com>
Subject: Re: ARM promising platform, needs to learn from PC.
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm suggesting splitting out the crazy part into a separate project
> that does this. Open-source. Like a mini-kernel.

 linus, i'm surprised, shocked even!  are you seriously proposing that
the linux kernel be split into two, ooo, i dunno... something along
the lines of a core and an OSKit v2.0?  the last time OSKit was
created it didn't go down too well :)  but seriously: yes, i also came
up with this idea, and, whilst it sounds like a great idea in
principle, it is merely "moving the problem".

 likewise with any other ideas such as allowing the linux kernel to be
a userspace application (running under L4KA or other microkernel).

 so i think you'll find that whilst such ideas are great in principle,
they merely solve _your_ stress levels, not anyone else's :)

> Because the thing is,
> the main kernel doesn't care, and _shouldn't_ care. Those board files
> are just noise.

 yes, and they're necessary.  they link everything together, for the
actual real-world manufacturer shipping the real-world customised
one-of-a-kind mass-volume product, of which there are merely many many
thousands if not millions of units sold.

 yes, it initially sounded like i was arguing "in favour" of those...
noisy-board-files, but you can see - if you read to the end of the
sentence - i'm most certainly not.

 this is where the "selfish patch is out, collaborative patches are
in" rule would come into play.

 under the proposed rule, such board files would *not* qualify.

 however, if that board file was for a device that was part of a
collaboration (such as: it was for the pandaboard, IMX53QSB, or its
hardware CAD/CAM files were available under an OSI-Approved License),
i would argue that it *should* qualify.

 i've listed examples of each, in the FAQ.

 it would be good to be able to clearly link each concrete example to
a real-world case where linux developers have clearly gone "argggh!",
to evaluate how effective the proposed "selfish is out, collaboration
is in" rule would be.

 l.
