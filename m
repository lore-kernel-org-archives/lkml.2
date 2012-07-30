Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2G3Ux4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 16:53:56 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35294 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab2G3Uxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 16:53:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: Gethering power management/policy hw drivers under drivers/power/? (Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences)
Date: Mon, 30 Jul 2012 22:59:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Alex Courbot <acourbot@nvidia.com>, Jean Pihet <j-pihet@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Liam Girdwood <lrg@ti.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-pm@vger.kernel.org
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com> <5015E8AE.8060404@nvidia.com> <20120730024049.GA10442@lizard>
In-Reply-To: <20120730024049.GA10442@lizard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207302259.39396.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 30, 2012, Anton Vorontsov wrote:
> On Mon, Jul 30, 2012 at 10:51:42AM +0900, Alex Courbot wrote:
> [...]
> > On the other hand I have just noticed that the apparently unrelated
> > Adaptive Voltage Scaling driver just appeared in drivers/power/avs.
> > So if Anton and David are ok with this, maybe I could put the power
> > sequences code in its own subdirectory within drivers/power.
> 
> Well, currently drivers/power/ is indeed just for power supply class
> subsystem and drivers. But if the trend is to gather power management
> ("policy") stuff under one directory, i.e.
> 
> drivers/
>   power/
>     supplies/    <- former "power supply class and drivers"
>     regulators/
>     idle/
>     cpuidle/
>     cpufreq/
>     devfreq/
>     avs/
>     ...
> 
> That would probably make sense, we could easily see the big picture.
> But if we're not going to do this long-term,

Yes, we may do this eventually, but surely not right now.

Thanks,
Rafael
