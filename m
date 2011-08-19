Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1HSLr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:47:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39633 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1HSLr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:47:28 -0400
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
Subject: Re: ARM promising platform, needs to learn from PC.
Date: Fri, 19 Aug 2011 13:47:16 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-10-server; KDE/4.6.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAPweEDxwyB6BekTc8PqyVBeAkK3oMv1ZQ_ZX=zuta10OdCy5Kw@mail.gmail.com> <201108191104.44422.florian@openwrt.org> <CAPweEDyStyuHhkdswfnm1TiaEkQ69L90z_r=ytfqaqWXgrghzg@mail.gmail.com>
In-Reply-To: <CAPweEDyStyuHhkdswfnm1TiaEkQ69L90z_r=ytfqaqWXgrghzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108191347.16990.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday 19 August 2011 12:57:38 Luke Kenneth Casson Leighton wrote:
> On Fri, Aug 19, 2011 at 10:04 AM, Florian Fainelli <florian@openwrt.org> 
wrote:
> > Hello,
> > 
> > On Friday 19 August 2011 04:02:33 Luke Kenneth Casson Leighton wrote:
> >> dear linus,
> >> 
> >> i've written this up, including some examples in FAQ form that would
> >> and would not satisfy the proposed "selfish-is-out, cooperation-is-in"
> >> patch-acceptance rule, here:
> >> http://lkcl.net/linux/linux-selfish.vs.cooperation.html
> >> 
> >> comments greatly appreciated, as would additional examples to add to the
> >> FAQ.
> > 
> > Most of your examples, especially the RDC is example is just badly
> > chosen.
> 
>  ok, that's good to hear - that's a valuable opinion to hear, on a
> work-in-progress, and i look forward to receiving positive
> contributions which help improve the document.  do you have any
> suggestions on how they might be improved?  or, do you have any other
> examples which might best fit?

Most if not all of the x86 platforms that I know about (OLPC, RDC, Moorestown, 
CE4100 ...) are supported, and they introduced positive refactoring of the x86 
code when they got submitted for inclusion.

> 
>  or, do you feel that the examples require further clarification, or
> perhaps references?

Yes, definitively include references in your document.

> 
>  positive thoughts and contributions will make progress, end-result an
> improvement of the lives of the Free Software Developers who work on
> the linux kernel.
> 
> > I had patches supporting this sub arch acccepted until we could get rid
> > of it and make it work with the generic x86 infrastructure. The only
> > thing that has not been accepted yet is some kind of "cpuid-like"
> > feature for RDC.
> > 
> > The rdc321x GPIO driver has been accepted mainline and only serves on
> > RDC- based SoC.
> 
>  ... and there are multiple devices using the RDC-based SoCs, yes?
> not just one hardware device, yes?  therefore, under the
> "collaboration is ok" proposed rule, it's "in".

Yes there are thousands of devices using that SoC out there.

> 
> i tell you what - i'll put in an extra example (preceding it), which
> says "we are a SoC manufacturer, we have created a custom CPU, we have
> placed it into one and only one hardware design, and we are
> restricting the SoC to sole and exclusive use in that hardware.
> please accept our one-SoC, one-design linux kernel patches".  Answer:
> not a cat in hell's chance.
> 
> is that sufficient explanation and clarification?

That's definitively clearer and better.

> 
> if not, what would you suggest?  in what way should the example be
> improved and clarified?
> 
> > Sorry to say that, but I do not understand the point of your FAQ,
> 
>  i apologise - the point is, as stated, to clarify through specific
> examples, the goal / aim of the proposed rule [punish selfish patches,
> reward cooperative and collaborative patches].
> 
>  the reason for doing so is quite simple: the goal / aim is so
> incredibly and profoundly simple that it may prove hard for people to
> appreciate.
> 
>  thus, the examples are some more "concrete" ways to guide people who
> are simply not used to thinking in strategic terms, "what is utterly
> utterly selfish" and "what is cooperative and collaborative".
> 
>  corporations are pathologically and utterly selfish beyond thought
> and reason, and will take, and take, and take, and take until all
> resources are consumed.
> 
>  much like Cancer.
> 
>  this is a way to stop that cancerous pathological consumption of Free
> Software Developers' resources.
> 
> > most people,
> > if explained with good reasons, would accept a new
> > architecture/SoC/sub-arch, but that's also at the price of the submitter
> > to eventually rethink its way of supporting the architecture (Device
> > Tree, code re-organisation ...).
> 
>  sorry to ask this, but could you clarify the "rethinking" that you
> are hypothetically suggesting?  for example, a code re-organisation
> that has some expected and anticipated benefit that would, under the
> *present* rules, be perfectly acceptable, and likewise for "Device
> Tree"?

I would direct you to LWN.net if you are not reading it already to better 
understand how using things like Device Tree can befenit in code reusing and 
IP blocks reusing in particular.

> 
>  the reason why i ask is because i think you'll find that certain
> kinds of code re-organisations as well as Device Tree redesigns would
> still fall into the category of "pure selfishness and free-loading on
> Free Software Developers' time and resources".
> 
>  i'd like to double-check that.

-- 
Florian
