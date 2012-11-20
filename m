Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2KTRJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:09:48 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41459 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2KTRJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:09:45 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
In-Reply-To: <20121117222718.GF31527@game.jcrosoft.org>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <509D9089.7020407@wwwdotorg.org> <20121117222718.GF31527@game.jcrosoft.org>
Date: Tue, 20 Nov 2012 17:09:39 +0000
Message-Id: <20121120170939.4F0043E102F@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2012 23:27:18 +0100, Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:
> On 16:23 Fri 09 Nov     , Stephen Warren wrote:
> > On 11/09/2012 09:28 AM, Grant Likely wrote:
> > However, I think the process for an end-user needs to be as simple as
> > "drop this .dts/.dtb file into some standard directory", and I imagine
> > it'll be much easier for distros/... to make that process work if
> > they're dealing with a .dtb that they can just blast into the kernel's
> > firmware loader interface, rather than having to also locate the
> > base-board .dts/.dtb file, and run dtc and/or other tools on both .dts
> > files together.
> I've exactly the same issue on Calao or the new atmel boards
> 
> We have lego boards
> 
> with different cpu-modues running on differetn mother boards with
> diferrentdaugther boards
> 
> on atmel we are lucky enough we can identity via 1-wire all of them but
> on Calao no
> 
> On Somfy platform we can detect hardware version and need different pinctrl
> 
> So personally I'll prefer to be able to request dtb from the kernel or push
> them from the userspace as it will depends where you will detect the hardware
> present
> 
> The main concern will which part of the kenel will now handle hw detection?

Along the lines of what you said above, it will depend on the board. If
the board /can/ be detected, then the kernel should do so and request
the appropriate configuration. If it cannot, then it simply must be left
up to either userspace or something explicit in the boot devicetree.

g.

