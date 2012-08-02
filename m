Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab2HBSLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 14:11:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49481 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290Ab2HBSLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 14:11:16 -0400
Date: Thu, 2 Aug 2012 19:11:12 +0100
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
Message-ID: <20120802181111.GM4537@opensource.wolfsonmicro.com>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <50170EA0.1010408@wwwdotorg.org>
 <501A338D.7080105@nvidia.com>
 <20120802082157.GA14866@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120802082157.GA14866@avionic-0098.adnet.avionic-design.de>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 10:21:57AM +0200, Thierry Reding wrote:
> On Thu, Aug 02, 2012 at 05:00:13PM +0900, Alex Courbot wrote:

> > The problem is, how do we turn these phandles into the resource of
> > interest. The type of the resource can be infered by the name of the
> > property. The hard part is resolving the resource from the phandle -
> > it seems like the API just does not allow to do this. GPIO has
> > of_get_named_gpio, but AFAIK there are no equivalent for regulator
> > consumer and PWM: the only way to use the DT with them is through
> > get_regulator and get_pwm which work at the device level.

> > Or is there a way that I overlooked?

> No, you are right. Perhaps we should add exported functions that do the
> equivalent of of_pwm_request() or the regulator_dev_lookup() and
> of_get_regulator() pair.

I missed some of the earlier bits of the thread here but why can't we do
device based lookups?
