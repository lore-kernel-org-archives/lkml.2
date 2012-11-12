Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab2KLQyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:54:08 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41946 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2KLQyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:54:05 -0500
Message-ID: <50A129AA.70406@wwwdotorg.org>
Date: Mon, 12 Nov 2012 09:54:02 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Rob Landley <rob@landley.net>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <1352666833.20434.5@driftwood> <ABAD0875-A618-405D-954F-CD76F09DDF04@antoniou-consulting.com>
In-Reply-To: <ABAD0875-A618-405D-954F-CD76F09DDF04@antoniou-consulting.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 05:50 AM, Pantelis Antoniou wrote:
> Hi Rob.
> 
> On Nov 11, 2012, at 10:47 PM, Rob Landley wrote:
> 
>>              On 11/09/2012 10:28:59 AM, Grant Likely wrote:
>>> On Tue, Nov 6, 2012 at 10:37 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> On 11/05/2012 01:40 PM, Grant Likely wrote:
>>> I'm not actually opposed to it, but it needs to be done in an elegant
>>> way. The DT data model already imposes more of a conceptual learning
>>> curve than I wish it did and I don't want to make that worse with a
>>> versioning model that is difficult to get ones head around.
>>
>> Speaking of which...
>>
>> I want to poke at board emulation in qemu, from scratch. Specifically, I want to start with an unpopulated board (just the processor), add a block of physical memory and a serial device, and boot an initramfs in there with stdin/stdout. Then I want to incrementally add an RTC, network card, and three block devices.
>>
>> I'd like to define this board by giving qemu and the kernel the same device tree they can parse, and I'd like to _build_ this device tree so I understand what's in it. I'd like to repeat this exercize for arm, mips, ppc, x86, x86-64, sparc, sh4, and maybe other boards.
>>
>> And I'd like to write up an article on doing it as a learning exercise.
>>
>> Last time I checked, doing this wasn't possible. (qemu couldn't define a board by parsing a device tree, the kernel used the device tree as a guideline but it only really read data the drivers you linked in were expecting, the only documentation about what any of the nodes were was was read the other device trees as examples or read the source code of the drivers looking for data in the tree...)
>>
>> Is it a more realistic project now? If so, where would I start? (Once upon a time I read the booting-without-of document, back when it lived in the ppc directory. It didn't really say what should go in any of the nodes.)
>>
>> Rob
> 
> It should be possible when the stuff we're talking about is ready.
> 
> I don't know what you'll find is broken during the exercise, but I guess
> your article is going to be entertaining at least :)

To be honest, I think Rob's proposal should be possible irrespective of
this conversation; if he wants to simply define the HW structure once
before running qemu, then none of this overlay discussion is relevant.

Perhaps the missing piece is the Documentation/devicetree/bindings/
directory?
