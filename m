Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0IFKXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 06:23:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50142 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0IFKXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 06:23:03 -0400
Subject: Re: [PATCH] regulator: wm8350-regulator - fix the logic of
 checking REGULATOR_MODE_STANDBY mode
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100906092305.GA10367@rakim.wolfsonmicro.main>
References: <1283753167.19378.1.camel@mola>
	 <20100906092305.GA10367@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Sep 2010 11:22:57 +0100
Message-ID: <1283768577.3078.13.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 10:23 +0100, Mark Brown wrote:
> On Mon, Sep 06, 2010 at 02:06:07PM +0800, Axel Lin wrote:
> > In wm8350_dcdc_set_mode(), we set DCx_SLEEP bit of WM8350_DCDC_SLEEP_OPTIONS
> > register for REGULATOR_MODE_STANDBY mode.
> > ( DCx_SLEEP bits: 0: Normal DC-DC operation 1: Select LDO mode )
> 
> > In wm8350_dcdc_get_mode(), current logic to determinate
> > REGULATOR_MODE_STANDBY mode is just reverse.
> > ( sleep is set should mean REGULATOR_MODE_STANDBY mode. )
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

All applied (last 4 regulator patches from Axel).

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

