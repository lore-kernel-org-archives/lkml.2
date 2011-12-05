Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab1LEP4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:56:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43002 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374Ab1LEP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:56:37 -0500
Date: Mon, 5 Dec 2011 15:56:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpiolib: introduce gpio_set_pullup
Message-ID: <20111205155634.GW11150@opensource.wolfsonmicro.com>
References: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
 <20111125153409.GA4975@sirena.org.uk>
 <4ED2045E.7010206@compulab.co.il>
 <20111129023708.GN15008@game.jcrosoft.org>
 <74CDBE0F657A3D45AFBB94109FB122FF174FDAFAC8@HQMAIL01.nvidia.com>
 <20111205154011.GE9192@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205154011.GE9192@game.jcrosoft.org>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 04:40:11PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 08:51 Tue 29 Nov     , Stephen Warren wrote:

> > I believe the pinctrl subsystem should be applicable to any chip, be it
> > the main SoC/CPU in the system, or any other chip. We don't currently
> > have any non-SoC drivers, but that's just because nobody has written them
> > yet; there's no technical reason they couldn't exist.

> sorry pinmux for gpio specific management i's overkill

If it's a GPIO-only device then probaby but lots of devices have a
fairly large range of signals that can be brought out on the pins (often
even more than a typical SoC actually).
