Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab1FWBZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:25:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48447 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758559Ab1FWBZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:25:47 -0400
Date: Thu, 23 Jun 2011 02:25:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 0/8] Generic I2C and SPI register map library
Message-ID: <20110623012544.GE20949@opensource.wolfsonmicro.com>
References: <20110622184407.GC13847@sirena.org.uk>
 <20110622224828.GA2342@siel.b>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622224828.GA2342@siel.b>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 12:48:28AM +0200, torbenh wrote:

> you should look at SMBus 
> there seems to be quite some code to share.
> in particular i2c rtc devices seem to be using SMBus functions
> to get the exact same semantics you are providing here.

SMBus is an I2C subset with a definition for 8 bit registers layered
onto it, pretty much.

> I just added support for such a device today, and it struck me, that
> this API was necessary.

If you're only using SMBus then the I2C interface includes SMBus based
register support which should do what you want.  With the regmap API it
ought to work as a device with 8 bit registers and 8 bit values.
