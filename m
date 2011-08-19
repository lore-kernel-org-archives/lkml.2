Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1HSNAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:00:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64558 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1HSNAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:00:11 -0400
MIME-Version: 1.0
In-Reply-To: <201108191347.16990.florian@openwrt.org>
References: <CAPweEDxwyB6BekTc8PqyVBeAkK3oMv1ZQ_ZX=zuta10OdCy5Kw@mail.gmail.com>
	<201108191104.44422.florian@openwrt.org>
	<CAPweEDyStyuHhkdswfnm1TiaEkQ69L90z_r=ytfqaqWXgrghzg@mail.gmail.com>
	<201108191347.16990.florian@openwrt.org>
Date: Fri, 19 Aug 2011 14:00:10 +0100
Message-ID: <CAPweEDymi8UX2pyAwysTA3oOc9Hwjj6fyFKa4-hrEXpkSWr-1A@mail.gmail.com>
Subject: Re: ARM promising platform, needs to learn from PC.
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 12:47 PM, Florian Fainelli <florian@openwrt.org> wrote:
> Hello,

 hii florian

> On Friday 19 August 2011 12:57:38 Luke Kenneth Casson Leighton wrote:
>> On Fri, Aug 19, 2011 at 10:04 AM, Florian Fainelli <florian@openwrt.org>
> wrote:
>> > Hello,
>> >
>> > On Friday 19 August 2011 04:02:33 Luke Kenneth Casson Leighton wrote:
>> >> dear linus,
>> >>
>> >> i've written this up, including some examples in FAQ form that would
>> >> and would not satisfy the proposed "selfish-is-out, cooperation-is-in"
>> >> patch-acceptance rule, here:
>> >> http://lkcl.net/linux/linux-selfish.vs.cooperation.html
>> >>
>> >> comments greatly appreciated, as would additional examples to add to the
>> >> FAQ.
>> >
>> > Most of your examples, especially the RDC is example is just badly
>> > chosen.
>>
>>  ok, that's good to hear - that's a valuable opinion to hear, on a
>> work-in-progress, and i look forward to receiving positive
>> contributions which help improve the document.  do you have any
>> suggestions on how they might be improved?  or, do you have any other
>> examples which might best fit?
>
> Most if not all of the x86 platforms that I know about (OLPC,

 ah you mean the Geode LX :)  beautiful chip.  self-clocking, no power
management needed.  amazing.

> RDC, Moorestown,
> CE4100 ...) are supported, and they introduced positive refactoring of the x86
> code when they got submitted for inclusion.

 yes.  ok.  i take it that the positive refactoring involved making
lives easier for all maintainers involved? thus it would count as
non-selfish collaboration, and would thus clearly and easily qualify
under the proposed rule.

>>
>>  or, do you feel that the examples require further clarification, or
>> perhaps references?
>
> Yes, definitively include references in your document.

 ok.  i'm working on that.  i'm looking for one in amongst this lot:
http://thread.gmane.org/gmane.linux.kernel/1114495/focus=112007

 it's the one i spotted where someone said that there were drivers
submitted by SoC manufacturers that, because the hard macro which he
referred to as a "node" e.g. a USB-2 macro came from the exact same
Silicon Design House, were exactly the same.  but because they were
submitted by different SoC manufacturers, the code was (evidently)
duplicated.

>>  ... and there are multiple devices using the RDC-based SoCs, yes?
>> not just one hardware device, yes?  therefore, under the
>> "collaboration is ok" proposed rule, it's "in".
>
> Yes there are thousands of devices using that SoC out there.

 then that would definitely count.  although, hypothetically, if those
thousands of devices were all from the one hardware supplier (i know
they're not in this case) then i would argue that it would not, on the
basis that it was "selfish" and "self-centred" of that hardware
supplier.

 then again, as you can see, i give *another* example where, despite
the selfish nature of the hardware supplier, it turns out that there
are dozens if not hundreds of people, unrelated to that hardware
supplier, who are collaborating and cooperating around that
"selfishly-designed" device, and i would argue that any patches
submitted by that community (or through the hardware supplier on
behalf of that community) *should* be accepted, if sufficient evidence
is presented which proves that collaboration and cooperation is taking
place.

 actually... funnily enough, many of the openwrt devices would qualify
as this kind of example! :)  they're designed utterly selfishly (and
usually GPL-violating), then Free Software Developers reverse-engineer
them and re-create the linux kernel sources, for the benefit of
others.

 so it's not a hard-and-fast rule, it's very very loose and generic,
aimed at turning the Linux Free Software Kernel _back_ into a
collaborative project, instead of being a lackey and a punching-bag
for a bunch of pathological corporations who sponge off of the
goodwill of the Free Software Community.


>> i tell you what - i'll put in an extra example (preceding it), which
>> says "we are a SoC manufacturer, we have created a custom CPU, we have
>> placed it into one and only one hardware design, and we are
>> restricting the SoC to sole and exclusive use in that hardware.
>> please accept our one-SoC, one-design linux kernel patches".  Answer:
>> not a cat in hell's chance.
>>
>> is that sufficient explanation and clarification?
>
> That's definitively clearer and better.

 ok good stuff.  added.

 thanks florian.

 l.
