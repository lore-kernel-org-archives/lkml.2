Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab2GaO0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:26:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53584 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab2GaO0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:26:09 -0400
Date: Tue, 31 Jul 2012 15:26:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alex Courbot <acourbot@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120731142607.GV4468@opensource.wolfsonmicro.com>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <50170EA0.1010408@wwwdotorg.org>
 <5017B434.2010706@nvidia.com>
 <20120731105640.GD16155@avionic-0098.adnet.avionic-design.de>
 <20120731141328.GS4468@opensource.wolfsonmicro.com>
 <20120731142216.GA19591@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731142216.GA19591@avionic-0098.adnet.avionic-design.de>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 04:22:17PM +0200, Thierry Reding wrote:
> On Tue, Jul 31, 2012 at 03:13:29PM +0100, Mark Brown wrote:

> > __devinit can be discarded if you disable enough kernel features,
> > HOTPLUG is the main one IIRC, modules might also need to go - drivers
> > really ought to take a copy of platform data they plan to use at
> > runtime, though practically speaking you have to try to trigger any
> > problems.

> HOTPLUG is marked EXPERT and explicitly states that it should only be
> disabled if you're not using modules or dynamic device discovery. I
> think if you've ignored all of that you're no longer entitled to
> complain.

This is framework code - it doesn't have much option.  Disabling HOTPLUG
is totally reasonable on space constrained systems, there's no reason
for the code to break things for people.
