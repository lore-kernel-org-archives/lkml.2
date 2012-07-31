Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2GaQmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:42:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33316 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab2GaQmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:42:49 -0400
Date: Tue, 31 Jul 2012 09:42:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Alex Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120731164245.GA5762@kroah.com>
References: <50170EA0.1010408@wwwdotorg.org>
 <5017B434.2010706@nvidia.com>
 <20120731105640.GD16155@avionic-0098.adnet.avionic-design.de>
 <20120731141328.GS4468@opensource.wolfsonmicro.com>
 <20120731142216.GA19591@avionic-0098.adnet.avionic-design.de>
 <20120731142607.GV4468@opensource.wolfsonmicro.com>
 <20120731143235.GA21126@avionic-0098.adnet.avionic-design.de>
 <20120731153941.GF4468@opensource.wolfsonmicro.com>
 <20120731161954.GB4941@kroah.com>
 <20120731162230.GE11892@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731162230.GE11892@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 05:22:30PM +0100, Mark Brown wrote:
> On Tue, Jul 31, 2012 at 09:19:54AM -0700, Greg Kroah-Hartman wrote:
> > On Tue, Jul 31, 2012 at 04:39:41PM +0100, Mark Brown wrote:
> > > On Tue, Jul 31, 2012 at 04:32:35PM +0200, Thierry Reding wrote:
> 
> > > > can gracefully handle its platform data being discarded.
> 
> > > Sure there is - take a copy of the platform data in probe().
> 
> > Ick ick ick, devdata needs to die as it's pretty much pointless these
> > days.
> 
> Hrm?  I'm not sure I understand the direct relevance here - we're
> talking about platform data.

The platform data was marked __devdata, and you said it could be thrown
away after init so you should keep it around somehow.

Anyway, not really the main point here at all, sorry for the noise...

greg k-h
