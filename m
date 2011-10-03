Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab1JCMkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:40:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58905 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754652Ab1JCMkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:40:46 -0400
Date: Mon, 3 Oct 2011 13:40:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
Subject: Re: [PATCH 1/3] mfd: allow mfd_cell association with device tree node
Message-ID: <20111003124044.GF3731@opensource.wolfsonmicro.com>
References: <20110927182636.GR4289@opensource.wolfsonmicro.com>
 <CAMLZHHR0rMZct2E91X8k+Lhv_y-pY_5+vshZw6dj194o9vSCJQ@mail.gmail.com>
 <20110927183832.GS4289@opensource.wolfsonmicro.com>
 <CAMLZHHRvr-diYGwZ2Kg647Ht7NNb8LEku0pCW8EujRuUeOW5yQ@mail.gmail.com>
 <20110928123154.GG3279@opensource.wolfsonmicro.com>
 <CAMLZHHRFY_MazF_MOzPrS06z-48-ohORTtbANMxUT=mjevXhhQ@mail.gmail.com>
 <20111003102846.GA23811@sirena.org.uk>
 <CAMLZHHTMP+DJA35bUswXPbTv_U0DAWY_h_-Eg53-_4RuC3bx7A@mail.gmail.com>
 <20111003121655.GB3731@opensource.wolfsonmicro.com>
 <CAMLZHHS+fFzuWtwOwt-g2y38g93uaZFyUGsooZyYLMT=mdWQFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMLZHHS+fFzuWtwOwt-g2y38g93uaZFyUGsooZyYLMT=mdWQFQ@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 01:30:15PM +0100, Daniel Drake wrote:
> On Mon, Oct 3, 2011 at 1:16 PM, Mark Brown

> > It seems to me like either the IP block is heavily dependant on the core
> > and shouldn't be split out in the device tree at all (but should instead
> > be part of the core node) or the IP block is very isolated from the core
> > (in which case we should just be able to instantiate the device from the
> > device tree without using explict code in the core driver).

> > This all feels like there's some abstraction violation going on.

> I guess it is a matter of opinion. To me, the abstraction is sensible
> and representative of the hardware.

> This also matches the way that the hardware is described by VIA in the
> specs, and it matches the way that Linux has its own device hierachy
> laid out (i.e. the ISA bridge driven by the mfd driver, which then
> spawns off a child device for the GPIO controller).

> It would not be possible to fold all of the isa bridge child
> components into the same device tree node without dealing with various
> namespace collisions.

So, I made two suggestions above and it sounds like you want the second
one but you've only responded to the first one without commenting on the
second.  My second suggestion was that if the block is sufficiently
isoltated from the core we should be able instantiate it from the device
tree without requiring explicit code in the core driver.
