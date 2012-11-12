Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab2KLKxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 05:53:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39852 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2KLKxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 05:53:53 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <CACxGe6vBYOoK9JdMV-ppUMuugmXcSfXYnh=-jCZP99BTkqKswg@mail.gmail.com>
Date: Mon, 12 Nov 2012 11:53:49 +0100
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 7BIT
Message-Id: <89EFC1DF-4471-49C4-9483-C67C57C73986@dominion.thruhere.net>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <509D9089.7020407@wwwdotorg.org> <CACxGe6vBYOoK9JdMV-ppUMuugmXcSfXYnh=-jCZP99BTkqKswg@mail.gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 10 nov. 2012, om 00:40 heeft Grant Likely <grant.likely@secretlab.ca> het volgende geschreven:

> On Fri, Nov 9, 2012 at 11:23 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 11/09/2012 09:28 AM, Grant Likely wrote:
>>> On Tue, Nov 6, 2012 at 10:37 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> ...
>>>> I do rather suspect this use-case is quite common. NVIDIA certainly has
>>>> a bunch of development boards with pluggable
>>>> PMIC/audio/WiFi/display/..., and I believe there's some ability to
>>>> re-use the pluggable components with a variety of base-boards.
>>>> 
>>>> Given people within NVIDIA started talking about this recently, I asked
>>>> them to enumerate all the boards we have that support pluggable
>>>> components, and how common it is that some boards support being plugged
>>>> into different main boards. I don't know when that enumeration will
>>>> complete (or even start) but hopefully I can provide some feedback on
>>>> how common the use-case is for us once it's done.
>>> 
>>> From your perspective, is it important to use the exact same .dtb
>>> overlays for those add-on boards, or is it okay to have a separate
>>> build of the overlay for each base tree?
>> 
>> I certainly think it'd be extremely beneficial to use the exact same
>> child board .dtb with arbitrary base boards.
>> 
>> Consider something like the Arduino shield connector format, which I
>> /believe/ has been re-used across a wide variety of Arduino boards and
>> other compatible or imitation boards. Now consider a vendor of an
>> Arduino shield. The shield vendor probably wants to publish a single
>> .dtb file that works for users irrespective of which board they're using
>> it with.
>> 
>> (Well, I'm not sure that Arduino can run Linux; perhaps that's why you
>> picked BeagleBone capes for your document!)
> 
> Correct, the Arduino is only an AVR with a tiny amount of ram. No Linux there.
> 
> However, Arduino shields are a good example of a use case. I think
> there are even some Arduino shield compatible Linux boards out there.

A good example of those would be the Rascal Micro: http://rascalmicro.com/

regards,

Koen