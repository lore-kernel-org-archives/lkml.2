Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0ITIqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:46:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41541 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab0ITIqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:46:31 -0400
Subject: Re: [PATCH] Regulator: lp3972 cleanup
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100917122844.GD4322@rakim.wolfsonmicro.main>
References: <1284702257.9481.3.camel@mola>
	 <20100917122844.GD4322@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 09:46:26 +0100
Message-ID: <1284972386.3403.20.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 13:28 +0100, Mark Brown wrote:
> On Fri, Sep 17, 2010 at 01:44:17PM +0800, Axel Lin wrote:
> 
> >  - Logging the value for diagnostics if failed to detect device
> 
> >  	if (ret == 0 && (val & SYS_CONTROL1_INIT_MASK) != SYS_CONTROL1_INIT_VAL)
> >  		ret = -ENODEV;
> >  	if (ret < 0) {
> > -		dev_err(&i2c->dev, "failed to detect device\n");
> > +		dev_err(&i2c->dev, "failed to detect device: %d\n", ret);
> 
> This misses part of the point of my suggestion - if you don't match the
> ID register then you'll log -ENODEV rather than the device ID that you
> read back which would presumably be more useful for someone trying to
> work out why the check triggered.
> 
> Lots of other good stuff in there, though:
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

