Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab2KOF00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 00:26:26 -0500
Received: from ozlabs.org ([203.10.76.45]:48790 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab2KOF0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 00:26:25 -0500
Date: Thu, 15 Nov 2012 15:57:18 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@wwwdotorg.org>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
Message-ID: <20121115045718.GJ32290@truffula.fritz.box>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <50999145.2070306@wwwdotorg.org>
 <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com>
 <509D9089.7020407@wwwdotorg.org>
 <5B124797-6DFD-4C5E-90D7-665AFD4A7873@antoniou-consulting.com>
 <50A12950.6090808@wwwdotorg.org>
 <20121113072517.GE25915@truffula.fritz.box>
 <BD20AE03-C138-4BC6-AE02-F162AF6840B2@antoniou-consulting.com>
 <CACxGe6vQxmAk_joUYbaXw4r8J3_RbQt22zFg84ANvcw+ycCMHg@mail.gmail.com>
 <7A051C2B-C4FB-41A0-8338-60B607EA3BC1@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A051C2B-C4FB-41A0-8338-60B607EA3BC1@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 03:38:18PM +0200, Pantelis Antoniou wrote:
> Hi Grant,
> 
> On Nov 13, 2012, at 2:24 PM, Grant Likely wrote:

> > On Tue, Nov 13, 2012 at 8:09 AM, Pantelis Antoniou
[snip]
> My intention wasn't never to make overlays overly portable. My intention
> was to make them in a way that portability can be introduced if the boards
> are 'close' enough, but not for arbitrary boards.
> 
> There have to be compatible interfaces both on the base, and the overlay
> dtbs.

Right.  And this is why I'm arguing that those interfaces should be
described explicitly - using existing OF mechanisms like interrupt-map
where possible, rather than having a very general, but very low-level
interface to make arbitrary changes to the DT.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
