Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3AGUX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 15:23:26 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:20314 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752924Ab3AGUXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 15:23:24 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18VVhwX8Fc3oF12Smwe4S2v
Date: Mon, 7 Jan 2013 12:23:06 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Subject: Re: [PATCH 1/5] capemgr: Beaglebone DT overlay based cape manager
Message-ID: <20130107202306.GH14149@atomide.com>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
 <1357584666-17374-2-git-send-email-panto@antoniou-consulting.com>
 <20130107200945.GF14149@atomide.com>
 <379B16EC-BFAA-4C27-8321-E7133C03368D@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <379B16EC-BFAA-4C27-8321-E7133C03368D@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [130107 12:16]:
> Hi Tony,
> 
> On Jan 7, 2013, at 10:09 PM, Tony Lindgren wrote:
> 
> > * Pantelis Antoniou <panto@antoniou-consulting.com> [130107 10:54]:
> >> A cape loader based on DT overlays and DT objects.
> >> 
> >> Beaglebone cape manager implementation.
> >> 
> >> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> >> ---
> >> arch/arm/mach-omap2/Kconfig            |    2 +
> >> drivers/misc/Kconfig                   |    2 +
> >> drivers/misc/Makefile                  |    1 +
> >> drivers/misc/cape/Kconfig              |    5 +
> >> drivers/misc/cape/Makefile             |    5 +
> >> drivers/misc/cape/beaglebone/Kconfig   |   11 +
> >> drivers/misc/cape/beaglebone/Makefile  |    5 +
> >> drivers/misc/cape/beaglebone/capemgr.c | 1835 ++++++++++++++++++++++++++++++++
> > 
> > The driver should probably be in drivers/bus?
> > 
> 
> It was a bus on the previous iteration and there was a flame storm of epic proportions.

Heh :)
 
> It is not a bus at all now, it's just a device loader; there are no
> bus constructs at all. I am at a loss to classify it really, so drivers/misc
> where every misfit ends up sounded OK.

Right..

> I'm open to suggestions though.

Well how about split it to an eeprom driver, and Linux generic
device loader parts?

Regards,

Tony
