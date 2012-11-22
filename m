Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2KVTjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:39:08 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37253 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab2KVTjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:39:05 -0500
MIME-Version: 1.0
In-Reply-To: <20121122020649.GH4371@opensource.wolfsonmicro.com>
References: <20121120215429.B621F3E1821@localhost> <13540495.epaCf4JVn9@percival>
 <50ACB59B.4090404@iki.fi> <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de>
 <50ACC341.3090204@ti.com> <20121121130039.GA12191@avionic-0098.adnet.avionic-design.de>
 <50ACD7DC.5060405@ti.com> <CAAVeFuJofYwj926=3v0ApBCq_vNhCdC1PnzDc-B3d=LL_L40Uw@mail.gmail.com>
 <20121121151209.GA4048@avionic-0098.adnet.avionic-design.de>
 <CAAVeFuK_V6nb874bygioi35mFNxaWuveKOedLT=YYsP4JfVqgA@mail.gmail.com> <20121122020649.GH4371@opensource.wolfsonmicro.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 22 Nov 2012 12:09:54 +0900
Message-ID: <CAAVeFu+zxQQ=8fTu1Fp21QrWp6yndsWHjEJ2Gi=LifviNKbvaA@mail.gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Tomi Valkeinen <tomba@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 11:06 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Nov 22, 2012 at 11:01:34AM +0900, Alexandre Courbot wrote:
>
>> The thing I don't understand here is why would anyone want power
>> sequences without the DT representation. Guys, that's the whole point! :)
>
>> If we are to implement things into drivers, then callback functions
>> are going to serve us just as well - even better, for they are more
>> flexible. All we need to do is define a dedicated ops structure and
>> have the driver plug the right callback functions depending on the
>> "compatible" property of the DT device node. We don't need a framework
>> for that.
>
> It allows drivers (both board drivers and actual drivers) to write these
> things in a semi-scripted form instead of having to open code everything
> each time, it'd save a bunch of tedious stuff with resource requesting
> for example.

Mmm, I overlooked that point - that's fair enough. Guess I should
remove all DT support and stress that point in the documentation. Then
maybe we'll have a deal.

Alex.
