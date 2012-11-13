Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2KMSfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:35:16 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38094 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2KMSfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:35:14 -0500
Message-ID: <50A2919D.5030006@wwwdotorg.org>
Date: Tue, 13 Nov 2012 11:29:49 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mitch Bradley <wmb@firmworks.com>
CC: David Gibson <david@gibson.dropbear.id.au>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Russ Dill <Russ.Dill@ti.com>, Scott Wood <scottwood@freescale.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <509D9089.7020407@wwwdotorg.org> <5B124797-6DFD-4C5E-90D7-665AFD4A7873@antoniou-consulting.com> <50A12950.6090808@wwwdotorg.org> <20121113072517.GE25915@truffula.fritz.box> <50A27BF1.4030502@wwwdotorg.org> <50A28D03.7050002@firmworks.com>
In-Reply-To: <50A28D03.7050002@firmworks.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 11:10 AM, Mitch Bradley wrote:
> It seems to me that this capebus discussion is missing an important
> point.  The name capebus suggests that it is a bus, so there should be a
> parent node to represent that bus.  It should have a driver whose API
> implements all of the system-interface functions a cape needs.

It was discussed earlier that capebus isn't actually a bus. It's simply
a collection of a bunch of pins from the SoC hooked up to connectors.
I'd agree that it's mis-named.
