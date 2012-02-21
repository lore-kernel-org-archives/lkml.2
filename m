Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab2BUSyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:54:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14329 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2BUSyW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:54:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 21 Feb 2012 10:54:13 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Colin Cross <ccross@android.com>,
        Chris Ball <cjb@laptop.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Feb 2012 10:54:12 -0800
Subject: RE: [PATCH 2/2] gpio: tegra: Delete tegra_gpio_enable/disable()
Thread-Topic: [PATCH 2/2] gpio: tegra: Delete tegra_gpio_enable/disable()
Thread-Index: Aczwhc5XeWjEe+1QSS6+Xig+qIs9rgARDntg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC383@HQMAIL01.nvidia.com>
References: <1329719263-18971-1-git-send-email-swarren@nvidia.com>
	<1329719263-18971-2-git-send-email-swarren@nvidia.com>
 <CACRpkdYDVU9TAVAAw=uBp84puED0kGkdSW8goAJRG1Nc=6xCaQ@mail.gmail.com>
In-Reply-To: <CACRpkdYDVU9TAVAAw=uBp84puED0kGkdSW8goAJRG1Nc=6xCaQ@mail.gmail.com>
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

Linus Walleij wrote at Tuesday, February 21, 2012 3:45 AM:
> On Mon, Feb 20, 2012 at 7:27 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > Recent pinctrl discussions concluded that gpio_request() and other gpiolib
> > APIs should in fact do whatever is required to mux a GPIO onto pins, by
> > calling pinctrl APIs if required. This change implements this for the
> > Tegra GPIO driver, and removes the old Tegra-specific APIs which did this.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > ---
> > I don't believe this depends on other patches.
> >
> > There may be some slight context dependencies; this patch was generated
> > against next-20120217, with my recently posted "gpio: tegra: Fix build
> > issue due to irq_domain rework." applied on top.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Since it mainly touches mach-tegra stuff I think it's best to take
> this through the Tegra tree, Olof can you queue it?

That makes sense to me, but just to be clear for Olof, best to defer
applying this until the discussion for patch 1 in the series is resolved;
this patch might need rework depending on the decisions there.

-- 
nvpublic

