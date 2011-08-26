Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1HZQHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:07:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18073 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1HZQHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:07:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 26 Aug 2011 09:07:03 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 26 Aug 2011 09:07:00 -0700
Subject: RE: [PATCH v3 00/13] arm/tegra: Initialize GPIO & pinmux from DT
Thread-Topic: [PATCH v3 00/13] arm/tegra: Initialize GPIO & pinmux from DT
Thread-Index: AcxjraSNAHrGl3f9QS2Cj+wS4qr0jQAW537g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B24A40D2@HQMAIL01.nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
 <CAOesGMiygfaNkPa7uURCiJpC=WDinWhKi07LFgJ+5JoGW_fLKw@mail.gmail.com>
In-Reply-To: <CAOesGMiygfaNkPa7uURCiJpC=WDinWhKi07LFgJ+5JoGW_fLKw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote at Thursday, August 25, 2011 11:05 PM:
> On Thu, Aug 25, 2011 at 4:43 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > v3:
...
> This is looking pretty sane to me.
> 
> Grant, how do you prefer to handle this, since it spans of/dt, gpio
> and tegra code? I can start a topic branch for Arnd to pull in for the
> tegra parts, would you prefer picking up the of helper functions on
> your own or is an ack from you and merge through the arm-soc tree
> easier?

I haven't thought through all the merging details yet, but do be aware
of the dependencies this patchset has:

1) Rename of arch/arm/mach-tegra/gpio.c -> drivers/gpio/gpio-tegra.c
   This is in Grant's gpio for-next branch, and hence linux-next.
   This is in some GPIO-related branch of Russell's.

2) Various previous Tegra <mach/gpio.h> rework.
   This is in some GPIO-related branch of Russell's; I assume the same one
   as (1), but I can't actually find this branch, so can't check.

Neither of those is in any Linus release or rc.

I *think* that's it.

For reference, this patchset was physical written/tested on top of
next-20110823, with the patches mentioned in (2) aboe, and some others that
hopefully aren't relevant, between linux-next and this patchset.

-- 
nvpublic

