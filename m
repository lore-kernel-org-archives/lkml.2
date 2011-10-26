Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab1JZNoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:44:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100Ab1JZNoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:44:03 -0400
Date: Wed, 26 Oct 2011 09:43:58 -0400
From: Dave Jones <davej@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: wm8400-core: select REGMAP_I2C in kconfig
Message-ID: <20111026134358.GA2048@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20111025185359.GA21019@redhat.com>
 <20111026071256.GA2915@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026071256.GA2915@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 09:12:59AM +0200, Mark Brown wrote:
 > On Tue, Oct 25, 2011 at 02:54:00PM -0400, Dave Jones wrote:
 > > wm8400-core.c is using the regmap I2C API, so needs to select it.
 > > 
 > > ERROR: "regmap_write" [drivers/mfd/wm8400-core.ko] undefined!
 > > ERROR: "regmap_raw_read" [drivers/mfd/wm8400-core.ko] undefined!
 > > ERROR: "regmap_read" [drivers/mfd/wm8400-core.ko] undefined!
 > > ERROR: "regmap_init_i2c" [drivers/mfd/wm8400-core.ko] undefined!
 > > ERROR: "regmap_bulk_read" [drivers/mfd/wm8400-core.ko] undefined!
 > > ERROR: "regmap_exit" [drivers/mfd/wm8400-core.ko] undefined!
 > 
 > Which kernel version are you looking at?  This is correct in my current
 > kernel - fixed in commit 2b247d06.  Though I suspect that's waiting to
 > trickle down into Linus' tree still.

That was yesterdays git (don't have the hash handy).  Today, as of
efb8d21b2c6db3497655cc6a033ae8a9883e4063 I can't reproduce it, though
I don't know why, as that file is definitly still using regmap, and there's
no select, and it's not in my .config.

	Dave

