Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab1HEI3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 04:29:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43629 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751046Ab1HEI3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 04:29:23 -0400
Date: Fri, 5 Aug 2011 09:29:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Liam Girdwood <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
Message-ID: <20110805082921.GA4977@opensource.wolfsonmicro.com>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com> <1312498820-2275-2-git-send-email-swarren@nvidia.com> <20110805000148.GB13321@opensource.wolfsonmicro.com> <74CDBE0F657A3D45AFBB94109FB122FF049F171EC1@HQMAIL01.nvidia.com> <20110805053510.GA16956@opensource.wolfsonmicro.com> <20110805080620.GE28651@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805080620.GE28651@trinity.fluff.org>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 09:06:20AM +0100, Ben Dooks wrote:

> I would say that setting the interrupt should deal with all the necessary
> configuration to get that interrupt working. In the case of pretty much all
> of the SoCs I have been involved with have always set the GPIO's function
> to allow the interrupt to pass through.

That's what Stephen is trying to do, essentially.  It's looking like
it's more sensible to fix it in the Tegra interrupt drivers, though.
