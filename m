Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0III34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 04:29:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41068 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0III3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 04:29:53 -0400
Date: Thu, 9 Sep 2010 09:29:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stuart Longland <redhatter@gentoo.org>
Cc: Ryan Mallon <ryan@bluewatersys.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Voltage/current/sensor monitoring interface and Wiegand
Message-ID: <20100909082942.GA23903@sirena.org.uk>
References: <20100909000245.GK14056@atomos.longlandclan.yi.org> <4C884AFA.20604@bluewatersys.com> <20100909050137.GR14056@atomos.longlandclan.yi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100909050137.GR14056@atomos.longlandclan.yi.org>
X-Cookie: Here there be tygers.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 03:01:37PM +1000, Stuart Longland wrote:

> Ahh okay, I'll have a look there..  The temperature isn't related to the
> power supply, so I might continue a searchfor its rightful place, but
> that class of devices seems like a good fit.

hwmon might be useful also (you can expose the same data via both
interfaces if you like).
