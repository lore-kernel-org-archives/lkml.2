Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab3AHMM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 07:12:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61721 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3AHMMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 07:12:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/5] capemgr: Beaglebone DT overlay based cape manager
Date: Tue, 8 Jan 2013 12:12:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Tony Lindgren <tony@atomide.com>,
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
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com> <21E7B891-269B-422D-9038-381FAA15B59B@antoniou-consulting.com> <20130108104832.GE21994@gmail.com>
In-Reply-To: <20130108104832.GE21994@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301081212.29089.arnd@arndb.de>
X-Provags-ID: V02:K0:e7DAYNrdQqmHqyCFGpjhQo3blRAUAGntEnFnedz4A4k
 UsJJPGMSBm+/0DoL1cEghCwKBJtY9SW8qVREb/ihmGzoj9bb6X
 1Nujdo/NCT/u3she+NLsYcPlEieyU1buBjLb2CRxpvjsQg+JDo
 R1cewYYrDynMcPZCGxJoCMPhNb6kVkj+4ZukPkcWZKYlyIPkg2
 ryFhgrFbArGISY58omV786BUO401nJEZJxDhM47dL3wncMRsYU
 4UGWMLkxJx5Y6OmD4sqF4kttjrJ6hiPQsG5uxXdp1sAWkLrE2B
 TwYXtv0rl0NFJmfQZ5cZOiThGDCzGM/Azo+5yMpTgmvEfC5FDZ
 PRVTX59j8+SpRUT3oRqw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2013, Lee Jones wrote:
> > If there is not, there is no way to automatically load the overlays; you can always
> > use the kernel command line, or have the a user space application to request the loading
> > of a specific board's overlay.
> 
> Unfortunately, there is no way to probe the UIBs. :(

I thought that some of the newer UIBs had it, just not the old ones.
As Pantelis says, we could at least detect the ones that have an EEPROM
on them, and use a command line option or device tree attribute for the others.

	Arnd
