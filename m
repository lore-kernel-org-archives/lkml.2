Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab0IFJXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:23:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41578 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750829Ab0IFJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:23:08 -0400
Date: Mon, 6 Sep 2010 10:23:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: wm8350-regulator - fix the logic of
 checking REGULATOR_MODE_STANDBY mode
Message-ID: <20100906092305.GA10367@rakim.wolfsonmicro.main>
References: <1283753167.19378.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283753167.19378.1.camel@mola>
X-Cookie: Welcome to the Zoo!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 02:06:07PM +0800, Axel Lin wrote:
> In wm8350_dcdc_set_mode(), we set DCx_SLEEP bit of WM8350_DCDC_SLEEP_OPTIONS
> register for REGULATOR_MODE_STANDBY mode.
> ( DCx_SLEEP bits: 0: Normal DC-DC operation 1: Select LDO mode )

> In wm8350_dcdc_get_mode(), current logic to determinate
> REGULATOR_MODE_STANDBY mode is just reverse.
> ( sleep is set should mean REGULATOR_MODE_STANDBY mode. )
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but *please* do try to make your commit messages clearer, it's difficult
to follow what you're sayin here, mostly because you don't explain how
you determined what change to make.
