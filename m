Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839Ab2BNJKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:10:33 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:44199 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab2BNJK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:10:29 -0500
Date: Tue, 14 Feb 2012 10:10:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Michael Lawnick <ml.lawnick@gmx.de>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: convert drivers/i2c/* to use module_i2c_driver()
Message-ID: <20120214101013.4133784e@endymion.delvare>
In-Reply-To: <20120213222643.GA22686@pengutronix.de>
References: <1329123903.13995.1.camel@phoenix>
	<20120213222643.GA22686@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 23:26:43 +0100, Wolfram Sang wrote:
> On Mon, Feb 13, 2012 at 05:05:03PM +0800, Axel Lin wrote:
> > This patch converts the drivers in drivers/i2c/* to use the
> > module_i2c_driver() macro which makes the code smaller and a bit simpler.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > Cc: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> > Cc: Jean Delvare <khali@linux-fr.org>
> > Cc: Michael Lawnick <ml.lawnick@gmx.de>
> > Cc: Ben Dooks <ben-linux@fluff.org>
> 
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>

Patch applied, thanks.

-- 
Jean Delvare
