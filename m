Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1HJPhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:37:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43524 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750922Ab1HJPhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:37:11 -0400
Date: Thu, 11 Aug 2011 00:37:06 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: soc-io: Add CONFIG_REGMAP_I2C/CONFIG_REGMAP_SPI
 guards for regmap_init_i2c/regmap_init_spi
Message-ID: <20110810153705.GH5724@opensource.wolfsonmicro.com>
References: <1312964652.11589.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312964652.11589.1.camel@phoenix>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:24:12PM +0800, Axel Lin wrote:
> In the case of "make da8xx_omapl_defconfig;make", the SPI support is disabled.
> Thus calling regmap_init_spi in soc-io.c has below build error.

Applied, thanks.
