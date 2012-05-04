Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab2EDUje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:39:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63199 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759621Ab2EDUjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:39:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfgang Denk <wd@denx.de>
Subject: Re: Handling of modular boards
Date: Fri, 4 May 2012 20:39:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com> <201205041934.08830.arnd@arndb.de> <20120504203357.6B79B206451@gemini.denx.de>
In-Reply-To: <20120504203357.6B79B206451@gemini.denx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205042039.25794.arnd@arndb.de>
X-Provags-ID: V02:K0:xb5VPUlMzQ3cmERFBgzNcNyZhIA3obkzS1Nrgz8+68z
 eC56nfIr11auKdFLekmRNIIrZ/3Bv42vjD5RX7S6saqIJKMbuP
 N++QzwQ8EiUYBJBf1MCOZsLNot01oSOkYmyfeBEoy6rJTmxazW
 /sogeeJ8Ze5S14COkPNpDjaODZO0rWWl3Fv2o1y/FWzrIyNl4K
 iotK0FwGkd+mBWJlBVGAoFSqo0vkGxUmrOLTy9m/jJjib24YGF
 KtfMYkI6+l3o4SVV1p90TcjcDbPGK9BkY33OKYYKZw8hxN4Axh
 d45hCRe10b1Uif3M7PmZsDWaSCrAtZoeM/UHZX2ytRfTUOx/q1
 XX5BxSfdHQwEpx2WvBow=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Wolfgang Denk wrote:
> In message <201205041934.08830.arnd@arndb.de> you wrote:
> >
> > One idea that I've heard before is to put device tree fragments into the
> > kernel and dynamically add them to the device tree that was passed by the
> > boot loader whenever we detect the presence of a specific device.
> > This obviously means it works only for boards using DT for booting, but
> > it allows us to use some infrastructure that we already have.
> > 
> > Another idea was to put all the possible extensions into the device tree
> > for a given board and disable them by default, putting it into the
> > responsibility of the boot loader to enable the one that is actually
> > being used. This has serious scalibility problems when there are many
> > possible extensions and also relies more on the boot loader than I would
> > like.
> 
> On the other hand, some of the issues we're trying to solve here
> for the kernel are also present in the boot loader, so this needs to
> do this anyway - whether by inserting new or modifying (enabling or
> disabling) existing properties in the DT is not really relevant here.

I haven't seen a case where the add-on board is actually required
for booting. What examples are you thinking of?

	Arnd
