Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab2KMTLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:11:46 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:39418 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754320Ab2KMTLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:11:45 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <50A29AD5.60303@firmworks.com>
Date: Tue, 13 Nov 2012 21:11:38 +0200
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Russ Dill <Russ.Dill@ti.com>, Scott Wood <scottwood@freescale.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 7bit
Message-Id: <4D5F9118-AD50-44F7-B672-2A70E5999CC1@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <509D9089.7020407@wwwdotorg.org> <5B124797-6DFD-4C5E-90D7-665AFD4A7873@antoniou-consulting.com> <50A12950.6090808@wwwdotorg.org> <20121113072517.GE25915@truffula.fritz.box> <50A27BF1.4030502@wwwdotorg.org> <50A28D03.7050002@firmworks.com> <50A2919D.5030006@wwwdotorg.org> <50A29AD5.60303@firmworks.com>
To: Mitch Bradley <wmb@firmworks.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mitch,

On Nov 13, 2012, at 9:09 PM, Mitch Bradley wrote:

> On 11/13/2012 8:29 AM, Stephen Warren wrote:
>> On 11/13/2012 11:10 AM, Mitch Bradley wrote:
>>> It seems to me that this capebus discussion is missing an important
>>> point.  The name capebus suggests that it is a bus, so there should be a
>>> parent node to represent that bus.  It should have a driver whose API
>>> implements all of the system-interface functions a cape needs.
>> 
>> It was discussed earlier that capebus isn't actually a bus. It's simply
>> a collection of a bunch of pins from the SoC hooked up to connectors.
>> I'd agree that it's mis-named.
>> 
> 
> Nevertheless, to the extent that the set of pins is finite and
> well-defined, it should be possible to define a set of software
> interfaces to support the functionality represented by those pins.
> 
> It might depend on the underlying SoC, but even so, it would still be
> best to encapsulate the interface set.  I hear all these use cases that
> presuppose a wide variety of user skill sets.  If one really wants to
> support such users well, it's important to define a coherent single
> point of interface.
> 
> 

That's what capebus is. Too bad there's such a fuss about the name.
Check out the thread from the start for the sordid details.

Regards

-- Pantelis

