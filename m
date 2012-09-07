Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992Ab2IGIcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:32:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5443 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2IGIck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:32:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 07 Sep 2012 01:32:07 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v5 2/4] pwm_backlight: use power sequences
Date: Fri, 7 Sep 2012 17:34:34 +0900
Message-ID: <1584217.aCLniK0dpS@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.1 (Linux/3.5.3-1-ARCH; KDE/4.9.1; x86_64; ; )
In-Reply-To: <20120907082835.GC17749@opensource.wolfsonmicro.com>
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com> <2360396.YKI4EihrfI@percival> <20120907082835.GC17749@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012 16:29:03 Mark Brown wrote:
> On Fri, Sep 07, 2012 at 05:28:17PM +0900, Alex Courbot wrote:
> > We could make power sequences an option of its own and add #ifdefs to
> > drivers that use it to lift this ambiguity, but I like the transparency
> > of the current way. It also seems hard (illegal?) to get rid of the
> > legacy DT interface.
> If you're doing this I'd suggest using stubs rather than ifdefs in the
> users, otherwise it's just going to cause lots of annoyance from
> randconfig build.  Is the code likely to big enough to worry about,
> though?

I don't think is will ever become big enough to bother. Moreover if the power 
seqs way meets acceptance, new drivers/frameworks are likely to use them as 
the only option, making it really mandatory.

Alex.

