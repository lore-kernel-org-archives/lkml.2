Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1HRUyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:54:02 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57361 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1HRUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:54:00 -0400
MIME-Version: 1.0
Date: Thu, 18 Aug 2011 21:53:59 +0100
Message-ID: <CAPweEDxwyB6BekTc8PqyVBeAkK3oMv1ZQ_ZX=zuta10OdCy5Kw@mail.gmail.com>
Subject: ARM promising platform, needs to learn from PC.
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dear linus,

am writing (publicly) to you again, as this issue still hasn't been
resolved.  i believe now that it is recognised, but we still don't see
any solutions.  allow me to summarise the main point of
https://lkml.org/lkml/2011/7/1/473 which is "set a patch rule: if it's
a common standard / platform / design, i.e. serves more than one
purpose, it's in".  that's all it takes.  this will force SoC vendors
as well as Hardware Manufacturers to collaborate around common
standards, common platforms and common designs.

http://linux.slashdot.org/comments.pl?sid=2386322&cid=37132660

"I think Linus is criticizing the lack of a common platform
surrounding ARM rather than the instructions themselves. The
instruction set of x86 chips has grown a lot, especially with x86_64,
but the way you boot a PC hasn't changed much for example."

note the word "common" in that paragraph.  there *is* no "common" in
ARM devices.

http://linux.slashdot.org/comments.pl?sid=2254082&cid=36506588

"Kind of. Actually things are not that bad. There are a lot of SoCs
out there which bundle an arm core with a few other cores (ethernet,
usb, etc). There are actually staggeringly few vendors for the
peripheral cores. The SoC vendors don't generally mention who the core
vendor is, but they provide a datasheet and stick the core at some
random place in the address space.

As a result, there are a lot of reimplementations of the same drivers.
This has been recognised and peopls are now trying to spot duplicate
drivers and replace them with a asingle unified one."

great!  such patches cover "common devices", and should be encouraged.
 but, any patch *adding* only one "core" for one device should be
placed right at the back of the patch queue, until such time as a 2nd
device using that same "core" comes along.  it then qualifies, and
it's in.

http://linux.slashdot.org/comments.pl?sid=2254082&cid=36506338

"The problem is as dense and layered as the chips themselves - what
really needs to happen is a standardized method for publishing SoC
features in a structured format (XML?) where common features (FIFO
registers with a bytes_remaining field? Write only configuration
registers, Read only configuration register.. etc) could be defined
and the code could in many cases just be automatically generated."

nice idea, which would qualify under the "common" rules.  but it
doesn't help resolve designs based on CPUs that exist *now*.  it would
still qualify, though, and would help with hardware designs scheduled
to be released some time in 2013 or 2014 (*if* more than one SoC
manufacturer adopted the idea right now).

http://linux.slashdot.org/comments.pl?sid=2254082&cid=36507840

"It would be much better to simply standardise the SoC, so that every
ARM system has the same basic elements. Just like a PC, where the
interrupt controller and memory are always in the same place, and the
timer always has the same register map."

yes.  this is just the tip of the iceberg as to why things are such a
dog's dinner right now.  the sheer diversity of deployment scenarios
for ARM CPUs, it being the world's most ubiquitous CPU after all
(between 1 and 3 ARM CPUs in virtually every single phone on the
planet), works against this idea.  but, again: if it *were* to happen,
then such systems, having "common design" at the CPU level, would
qualify.  i don't hold out much hope of it happening though :)


soo, linus.  you know the score, just as much as everyone else does.
everyone - yourself included - is describing the problem, and no real
solutions.  the solution i propose - "reject selfish patches" - is
sufficiently generic to be pretty much deployed right across the
entire linux kernel tree, and it just so happens that the entire x86
architecture *accidentally* is a wholly-owned subset of this proposed
solution.

that just leaves how - or when - such a proposed gets implemented. the
only person with the power to galvanise people to act towards being
less f*****g selfish is... you.  nobody else.  asking people to "get a
grip" doesn't help: they have to know how high to jump, which
direction and which foot to stand on when they commit themselves to a
gravity-defying leap of faith.

so don't arse about: put your foot down!

good luck,

l.
