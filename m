Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1HXJ3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:29:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34352 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750888Ab1HXJ3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:29:43 -0400
Date: Wed, 24 Aug 2011 10:29:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [linux-next] ASoC: build failure if CONFIG_I2C=m && CONFIG_SPI=y
 && CONFIG_SND_SOC=y
Message-ID: <20110824092941.GC15687@opensource.wolfsonmicro.com>
References: <1314099960.13722.1.camel@phoenix>
 <20110823104253.d7768c82.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823104253.d7768c82.rdunlap@xenotime.net>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 10:42:53AM -0700, Randy Dunlap wrote:

> I don't know if this is the same failure or just similar:

> ERROR: "regmap_exit" [drivers/mfd/wm8400-core.ko] undefined!

No, that's totally unrelated.  Fixed now.
