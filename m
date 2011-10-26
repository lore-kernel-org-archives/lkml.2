Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1JZHNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 03:13:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60251 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab1JZHN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 03:13:29 -0400
Date: Wed, 26 Oct 2011 09:12:59 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: wm8400-core: select REGMAP_I2C in kconfig
Message-ID: <20111026071256.GA2915@opensource.wolfsonmicro.com>
References: <20111025185359.GA21019@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025185359.GA21019@redhat.com>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 02:54:00PM -0400, Dave Jones wrote:
> wm8400-core.c is using the regmap I2C API, so needs to select it.
> 
> ERROR: "regmap_write" [drivers/mfd/wm8400-core.ko] undefined!
> ERROR: "regmap_raw_read" [drivers/mfd/wm8400-core.ko] undefined!
> ERROR: "regmap_read" [drivers/mfd/wm8400-core.ko] undefined!
> ERROR: "regmap_init_i2c" [drivers/mfd/wm8400-core.ko] undefined!
> ERROR: "regmap_bulk_read" [drivers/mfd/wm8400-core.ko] undefined!
> ERROR: "regmap_exit" [drivers/mfd/wm8400-core.ko] undefined!

Which kernel version are you looking at?  This is correct in my current
kernel - fixed in commit 2b247d06.  Though I suspect that's waiting to
trickle down into Linus' tree still.
