Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab2HUIvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:51:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11373 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab2HUIve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:51:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 21 Aug 2012 01:51:32 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Date: Tue, 21 Aug 2012 17:53:27 +0900
Message-ID: <1860040.h1S5hbLDAH@percival>
Organization: NVIDIA
User-Agent: KMail/4.9 (Linux/3.4.9-1-ARCH; KDE/4.9.0; x86_64; ; )
In-Reply-To: <20120821083329.GA28992@avionic-0098.adnet.avionic-design.de>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com> <1562509.b0FYTUZ1D8@percival> <20120821083329.GA28992@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2012 16:33:30 Thierry Reding wrote:
> I suppose power sequences aren't needed if you have a specific driver
> for every panel out there. However that also means that you'd have to
> write drivers for literally every panel that requires support. In the
> end this will just result in discussion down the road how the common
> functionality can be refactored and we may end up with power sequences
> again.
> 
> Also as you mentioned, power sequences are useful for a number of other
> use-cases. Without power sequences you'll have to potentially create
> extra frameworks tha reimplement parts of the power sequence code for
> their specific hardware needs.

Yes, I can imagine what a mess it would become it we had one driver for every 
panel out there which sole purpose would be to define power sequences over more 
generic drivers. That reassures me about the usefulness of this work.

Another (small) benefit of power sequences over specific drivers is that being 
defined in the DT, they would allow an old kernel to operate a newer device if 
the base driver is the same.

Alex.

