Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2IMOvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:51:12 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:53452 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052Ab2IMOvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:51:10 -0400
Date: Thu, 13 Sep 2012 17:51:05 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 1/4] i2c: introduce i2c-cbus driver
Message-ID: <20120913145104.GA8849@blackmetal.musicnaut.iki.fi>
References: <1346703805-31598-1-git-send-email-aaro.koskinen@iki.fi>
 <1346703805-31598-2-git-send-email-aaro.koskinen@iki.fi>
 <20120913105309.GF14237@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913105309.GF14237@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 12:53:09PM +0200, Wolfram Sang wrote:
> On Mon, Sep 03, 2012 at 11:23:22PM +0300, Aaro Koskinen wrote:
> > Add i2c driver to enable access to devices behind CBUS on Nokia Internet
> > Tablets.
> > 
> > The patch also adds CBUS I2C configuration for N8x0 which is one of the
> > users of this driver.
> > 
> > Cc: linux-i2c@vger.kernel.org
> > Acked-by: Felipe Balbi <balbi@ti.com>
> > Acked-by: Tony Lindgren <tony@atomide.com>
> > Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> 
> My main question is: what is CBUS? It doesn't look like an I2C/SMBUS
> host controller, but some bit-banging protocol? As such, it shouldn't go
> to i2c/busses/. And the protocol doesn't look much like I2C, neither.
> There is no ACK/NACK/START/STOP, so I wonder if it should be in i2c
> after all...

It's some legacy 3-wire bus protocol. Not much info is available,
there's some references to CBUS in i2c spec, so I thought it wouldn't
be a completly wrong place for it...

A.
