Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab3AHN0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:26:49 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:52766 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756254Ab3AHN0r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:26:47 -0500
Subject: Re: [PATCH 1/5] capemgr: Beaglebone DT overlay based cape manager
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <201301081212.29089.arnd@arndb.de>
Date: Tue, 8 Jan 2013 15:26:36 +0200
Cc: Lee Jones <lee.jones@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
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
Content-Transfer-Encoding: 8BIT
Message-Id: <51A6DFCC-BBC8-475D-88C4-1B22186339C1@antoniou-consulting.com>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com> <21E7B891-269B-422D-9038-381FAA15B59B@antoniou-consulting.com> <20130108104832.GE21994@gmail.com> <201301081212.29089.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Jan 8, 2013, at 2:12 PM, Arnd Bergmann wrote:

> On Tuesday 08 January 2013, Lee Jones wrote:
>>> If there is not, there is no way to automatically load the overlays; you can always
>>> use the kernel command line, or have the a user space application to request the loading
>>> of a specific board's overlay.
>> 
>> Unfortunately, there is no way to probe the UIBs. :(
> 
> I thought that some of the newer UIBs had it, just not the old ones.
> As Pantelis says, we could at least detect the ones that have an EEPROM
> on them, and use a command line option or device tree attribute for the others.
> 
> 	Arnd

So I gather the new ones have an eeprom?

Regards

-- Pantelis

