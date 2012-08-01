Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab2HAN0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:26:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43460 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991Ab2HAN0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:26:53 -0400
Date: Wed, 1 Aug 2012 14:26:51 +0100
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
Message-ID: <20120801132651.GU11892@opensource.wolfsonmicro.com>
References: <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <50170EA0.1010408@wwwdotorg.org>
 <5017B434.2010706@nvidia.com>
 <20120731105640.GD16155@avionic-0098.adnet.avionic-design.de>
 <20120731141328.GS4468@opensource.wolfsonmicro.com>
 <20120731142216.GA19591@avionic-0098.adnet.avionic-design.de>
 <20120731142607.GV4468@opensource.wolfsonmicro.com>
 <20120731143235.GA21126@avionic-0098.adnet.avionic-design.de>
 <20120731153941.GF4468@opensource.wolfsonmicro.com>
 <20120801074113.GF29673@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801074113.GF29673@avionic-0098.adnet.avionic-design.de>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 09:41:13AM +0200, Thierry Reding wrote:
> On Tue, Jul 31, 2012 at 04:39:41PM +0100, Mark Brown wrote:

> > Sure there is - take a copy of the platform data in probe().

> Yes, but that will only work for built-in drivers. If you unload the
> module and that causes the platform data to be discarded, reloading
> won't work.

This is why __devinit data will only be discarded when this is not
possible.
