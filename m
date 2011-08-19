Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1HSK5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:57:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59848 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1HSK5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:57:40 -0400
MIME-Version: 1.0
In-Reply-To: <201108191104.44422.florian@openwrt.org>
References: <CAPweEDxwyB6BekTc8PqyVBeAkK3oMv1ZQ_ZX=zuta10OdCy5Kw@mail.gmail.com>
	<CAPweEDzY7BQ_yxY1hVZdW8dL4GzQ_t=0KcXP_Mp45XrRShJ14Q@mail.gmail.com>
	<201108191104.44422.florian@openwrt.org>
Date: Fri, 19 Aug 2011 11:57:38 +0100
Message-ID: <CAPweEDyStyuHhkdswfnm1TiaEkQ69L90z_r=ytfqaqWXgrghzg@mail.gmail.com>
Subject: Re: ARM promising platform, needs to learn from PC.
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 10:04 AM, Florian Fainelli <florian@openwrt.org> wrote:
> Hello,
>
> On Friday 19 August 2011 04:02:33 Luke Kenneth Casson Leighton wrote:
>> dear linus,
>>
>> i've written this up, including some examples in FAQ form that would
>> and would not satisfy the proposed "selfish-is-out, cooperation-is-in"
>> patch-acceptance rule, here:
>> http://lkcl.net/linux/linux-selfish.vs.cooperation.html
>>
>> comments greatly appreciated, as would additional examples to add to the
>> FAQ.
>
> Most of your examples, especially the RDC is example is just badly chosen.

 ok, that's good to hear - that's a valuable opinion to hear, on a
work-in-progress, and i look forward to receiving positive
contributions which help improve the document.  do you have any
suggestions on how they might be improved?  or, do you have any other
examples which might best fit?

 or, do you feel that the examples require further clarification, or
perhaps references?

 positive thoughts and contributions will make progress, end-result an
improvement of the lives of the Free Software Developers who work on
the linux kernel.


> I had patches supporting this sub arch acccepted until we could get rid of it
> and make it work with the generic x86 infrastructure. The only thing that has
> not been accepted yet is some kind of "cpuid-like" feature for RDC.
>
> The rdc321x GPIO driver has been accepted mainline and only serves on RDC-
> based SoC.

 ... and there are multiple devices using the RDC-based SoCs, yes?
not just one hardware device, yes?  therefore, under the
"collaboration is ok" proposed rule, it's "in".

i tell you what - i'll put in an extra example (preceding it), which
says "we are a SoC manufacturer, we have created a custom CPU, we have
placed it into one and only one hardware design, and we are
restricting the SoC to sole and exclusive use in that hardware.
please accept our one-SoC, one-design linux kernel patches".  Answer:
not a cat in hell's chance.

is that sufficient explanation and clarification?

if not, what would you suggest?  in what way should the example be
improved and clarified?

> Sorry to say that, but I do not understand the point of your FAQ,

 i apologise - the point is, as stated, to clarify through specific
examples, the goal / aim of the proposed rule [punish selfish patches,
reward cooperative and collaborative patches].

 the reason for doing so is quite simple: the goal / aim is so
incredibly and profoundly simple that it may prove hard for people to
appreciate.

 thus, the examples are some more "concrete" ways to guide people who
are simply not used to thinking in strategic terms, "what is utterly
utterly selfish" and "what is cooperative and collaborative".

 corporations are pathologically and utterly selfish beyond thought
and reason, and will take, and take, and take, and take until all
resources are consumed.

 much like Cancer.

 this is a way to stop that cancerous pathological consumption of Free
Software Developers' resources.


> most people,
> if explained with good reasons, would accept a new architecture/SoC/sub-arch,
> but that's also at the price of the submitter to eventually rethink its way of
> supporting the architecture (Device Tree, code re-organisation ...).

 sorry to ask this, but could you clarify the "rethinking" that you
are hypothetically suggesting?  for example, a code re-organisation
that has some expected and anticipated benefit that would, under the
*present* rules, be perfectly acceptable, and likewise for "Device
Tree"?

 the reason why i ask is because i think you'll find that certain
kinds of code re-organisations as well as Device Tree redesigns would
still fall into the category of "pure selfishness and free-loading on
Free Software Developers' time and resources".

 i'd like to double-check that.
