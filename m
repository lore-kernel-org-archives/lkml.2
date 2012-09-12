Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072Ab2ILPxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:53:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53439 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759773Ab2ILPxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:53:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 04/16] ARM: imx: move platform_data definitions
Date: Wed, 12 Sep 2012 15:52:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Cox <alan@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Shawn Guo <shawn.guo@linaro.org>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <201209111410.05698.arnd@arndb.de> <Pine.LNX.4.64.1209111624240.22084@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1209111624240.22084@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209121552.26004.arnd@arndb.de>
X-Provags-ID: V02:K0:cMpqFPCJcSvMYFiZZVj0mG78zG7nuSwM5+Nn1agep38
 near0ru8weO7NUZ6wOYUGAYfhqjsFVaHlmDy0Sg6vqJOz57ul6
 +wnM69Ch0sZWdDIi9wjZm1/IkFeFv1dIdWJrC++ObflNoGhlXN
 sgyFAcJ/UEnqk0Pd7wEX6mJ+fnjDLsHiyJB4uand4ZS2yC6yKF
 GX6Wjz/2Ou9Fhu+v2fASh26F0RKCDhWV5f0L1wnHAuS7zMb6iz
 1kpvzLB9FeM3RtZKg9/Qv5bpi2edSrgNkiySjczAcNaE21zSjj
 TgFEXuFp/XAFFjZXFuM6aoW2T81LLraOynXeDAx6H3WC3gOM9i
 B8O4PxSVe1WngMYQtk04=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2012, Guennadi Liakhovetski wrote:
> ipu.h is used by the dmaengine and IRQ driver under drivers/dma/ipu/, and 
> by its users drivers/media/platform/soc_camera/mx3_camera.c and 
> drivers/video/mx3fb.c. It has been placed under arch/arm/... because it's 
> arch-specific, but in principle I don't see any reason why it cannot 
> happily live anywhere under include/...

Right. We can do that as the next step, after the pure platform data is
out of the way.

	Arnd
