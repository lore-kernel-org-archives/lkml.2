Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab2KFUuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:50:40 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:60006 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2KFUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:50:38 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6sJXubOSGGg5AmDK6DQMjv60H44nax9wUnnCGsqXGbfxw@mail.gmail.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
 <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com>
 <A5170602-2AE7-4EC4-BE0F-0DF015A287D7@antoniou-consulting.com> <CACxGe6sJXubOSGGg5AmDK6DQMjv60H44nax9wUnnCGsqXGbfxw@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 6 Nov 2012 20:50:17 +0000
X-Google-Sender-Auth: fEiWtcmP-GjpxiyXx57Q6Lk9CAA
Message-ID: <CACxGe6t-_CLOdkMLbErSu_dYkXRkCpwHA=obRr=nRCUCSOCW5Q@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Rob Herring <robherring2@gmail.com>, Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 8:45 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> The back of a napkin calculation indicates that on this platform
> /proc/devicetree costs 76kB and /sys/device-tree costs 60kb. I'm happy
> to see that using /sys instead of /proc appears to be slightly cheaper
> which makes it easier to justify the change. The diffstat makes me
> even happier:
>
> arch/arm/plat-omap/Kconfig                |    1 -
>  arch/powerpc/platforms/pseries/dlpar.c    |   23 -----------
>  arch/powerpc/platforms/pseries/reconfig.c |   40 ------------------
>  drivers/of/Kconfig                        |    8 ----
>  drivers/of/base.c                         |  116
> ++++++++++++++++++++++++++++------------------------
>  drivers/of/fdt.c                          |    5 ++-
>  fs/proc/Makefile                          |    1 -
>  fs/proc/proc_devtree.c                    |   13 +-----
>  fs/proc/root.c                            |    4 +-
>  include/linux/of.h                        |   35 ++++++++++++----
>  include/linux/proc_fs.h                   |   16 --------
>  include/linux/string.h                    |   11 +++++
>  12 files changed, 107 insertions(+), 166 deletions(-)

Make that 96 insertions. I got an extra patch caught up in that diffstat.

g.
