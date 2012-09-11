Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab2IKNlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:41:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63965 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab2IKNle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:41:34 -0400
Date: Tue, 11 Sep 2012 15:40:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 04/16] ARM: imx: move platform_data definitions
In-Reply-To: <1347368390-31252-4-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.1209111538000.22084@axis700.grange>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:PBCdstt3bPWirIvGbmdvLz8+ZsceXONNSFNBBHALWNM
 wvGjmWwVwFsGV0u2K4mWNF+MVJYkUAhvoUpg7ieSywAyoQXJGN
 kyg+4tmEThBUKBzVkiIkWKOmsF4j6bmj7OVxFeYBGuiPjmorhJ
 SfzKawebf/VQk+aQv7RkGONPL7barfk2FGBMeg4XD5mt0498KV
 LVA6TslQRprgTZgRNHYguVlUT2Fk+DX2orhSiQ2uqEDY+KpiEG
 7KAV5UPjHA6hoz79X/XncsiDbUIkppCtFFqP4JGrznuood+FuN
 QN5gadaFYmBYyh3xzXDLFsk0jGagYpcu3m92B4J4YpzY64PvMc
 0x7Y+T+aLQDdBUylNrOe9oKsznWa6a57g9GpFjxw7k3esz9mfq
 mjN2ZHh0MUTqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd

It probably wouldn't be very difficult to also include 
arch/arm/plat-mxc/include/mach/ipu.h in this your patch, but you can also 
leave it for later. Just to make sure it's not something that would make 
your future patching more complicated.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
