Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab2IGI3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:29:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35324 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752995Ab2IGI3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:29:16 -0400
Date: Fri, 7 Sep 2012 16:29:03 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
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
Message-ID: <20120907082835.GC17749@opensource.wolfsonmicro.com>
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com>
 <1346412846-17102-3-git-send-email-acourbot@nvidia.com>
 <50478B07.4080708@wwwdotorg.org>
 <2360396.YKI4EihrfI@percival>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2360396.YKI4EihrfI@percival>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 05:28:17PM +0900, Alex Courbot wrote:

> We could make power sequences an option of its own and add #ifdefs to drivers 
> that use it to lift this ambiguity, but I like the transparency of the current 
> way. It also seems hard (illegal?) to get rid of the legacy DT interface.

If you're doing this I'd suggest using stubs rather than ifdefs in the
users, otherwise it's just going to cause lots of annoyance from
randconfig build.  Is the code likely to big enough to worry about,
though?
