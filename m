Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab3AIILk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:11:40 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:56846 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193Ab3AIILh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:11:37 -0500
Date: Wed, 9 Jan 2013 08:11:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/5] capemgr: Beaglebone DT overlay based cape manager
Message-ID: <20130109081131.GH21994@gmail.com>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
 <201301081212.29089.arnd@arndb.de>
 <51A6DFCC-BBC8-475D-88C4-1B22186339C1@antoniou-consulting.com>
 <201301081612.59292.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201301081612.59292.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jan 2013, Arnd Bergmann wrote:

> On Tuesday 08 January 2013, Pantelis Antoniou wrote:
> > On Jan 8, 2013, at 2:12 PM, Arnd Bergmann wrote:
> > 
> > > On Tuesday 08 January 2013, Lee Jones wrote:
> > >>> If there is not, there is no way to automatically load the overlays; you can always
> > >>> use the kernel command line, or have the a user space application to request the loading
> > >>> of a specific board's overlay.
> > >> 
> > >> Unfortunately, there is no way to probe the UIBs. :(
> > > 
> > > I thought that some of the newer UIBs had it, just not the old ones.
> > > As Pantelis says, we could at least detect the ones that have an EEPROM
> > > on them, and use a command line option or device tree attribute for the others.
> > > 
> > >       Arnd
> > 
> > So I gather the new ones have an eeprom?
> 
> I don't remember the details unfortunately. Lee should be the one who can find out.
> IIRC there was at least a single integeger number on them.

Not as far as I can remember. There was (is?) a crude method of
identifying UIBs, but attempting to obtain certain I2C lines and
testing which ones were accessible. However, if there is an issue
with I2C, the wrong UIB was 'probed'.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
