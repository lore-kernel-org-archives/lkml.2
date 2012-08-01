Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2HAAxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 20:53:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40697 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2HAAxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 20:53:31 -0400
Date: Tue, 31 Jul 2012 17:51:17 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alex Courbot <acourbot@nvidia.com>, Jean Pihet <j-pihet@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: Gethering power management/policy hw drivers under
 drivers/power/? (Re: [RFC][PATCH v3 1/3] runtime interpreted power
 sequences)
Message-ID: <20120801005117.GA1798@lizard>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <5015E8AE.8060404@nvidia.com>
 <20120730024049.GA10442@lizard>
 <201207302259.39396.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201207302259.39396.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 10:59:39PM +0200, Rafael J. Wysocki wrote:
[...]
> > Well, currently drivers/power/ is indeed just for power supply class
> > subsystem and drivers. But if the trend is to gather power management
> > ("policy") stuff under one directory, i.e.
> > 
> > drivers/
> >   power/
> >     supplies/    <- former "power supply class and drivers"
> >     regulators/
> >     idle/
> >     cpuidle/
> >     cpufreq/
> >     devfreq/
> >     avs/
> >     ...
> > 
> > That would probably make sense, we could easily see the big picture.
> > But if we're not going to do this long-term,
> 
> Yes, we may do this eventually, but surely not right now.

OK, great! Then I'll probably start thinking about moving power supply
drivers into its own directory, maybe in 3.7.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
