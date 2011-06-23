Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab1FWKo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:44:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53245 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759157Ab1FWKo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:44:28 -0400
Date: Thu, 23 Jun 2011 11:44:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 0/8] Generic I2C and SPI register map library
Message-ID: <20110623104425.GE21932@opensource.wolfsonmicro.com>
References: <20110622184407.GC13847@sirena.org.uk>
 <20110622224828.GA2342@siel.b>
 <20110623012544.GE20949@opensource.wolfsonmicro.com>
 <4E02FF41.1060000@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E02FF41.1060000@cam.ac.uk>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 09:54:25AM +0100, Jonathan Cameron wrote:
> On 06/23/11 02:25, Mark Brown wrote:

> > If you're only using SMBus then the I2C interface includes SMBus based
> > register support which should do what you want.  With the regmap API it
> > ought to work as a device with 8 bit registers and 8 bit values.

> The kicker here is that quite a few hosts only support the smbus subset.
> How should that be handled here?

For 8x8 registers we *should* end up only using the SMBus subset so it
should just work.
