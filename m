Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab1CRPbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:31:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51195 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab1CRPbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:31:11 -0400
Date: Fri, 18 Mar 2011 15:31:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Waldemar.Rymarkiewicz@tieto.com
Cc: w.sang@pengutronix.de, linux-i2c@vger.kernel.org, arnd@arndb.de,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        hthebaud@insidefr.com, matti.j.aaltonen@nokia.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Message-ID: <20110318153104.GE27129@sirena.org.uk>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com> <20110318114931.GA2155@pengutronix.de> <99B09243E1A5DA4898CDD8B700111448108588196C@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99B09243E1A5DA4898CDD8B700111448108588196C@EXMB04.eu.tieto.com>
X-Cookie: How do I get HOME?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 05:08:39PM +0200, Waldemar.Rymarkiewicz@tieto.com wrote:
> Wolfram,

> >> +	unsigned int irq_gpio;
> >> +	unsigned int ioh_gpio;

> >... you should request and setup the GPIOs before using them.

> I assume the board specific code will do so. 

The usual pattern is that the code which uses the GPIO requests it,
otherwise all the users just end up having to replicate the setup and
teardown code for them.
