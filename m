Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1HLAMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 20:12:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45161 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754509Ab1HLAMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 20:12:05 -0400
Subject: Re: linux-next: Tree for Aug 11 (sound/soc + regmap)
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Liam Girdwood <lrg@ti.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
In-Reply-To: <20110811121459.b235aff5.rdunlap@xenotime.net>
References: <20110811162058.42b462bc80e67d7a80ecff93@canb.auug.org.au>
	 <20110811121459.b235aff5.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Wolfson Microelectronics
Date: Fri, 12 Aug 2011 09:11:59 +0900
Message-ID: <1313107919.19990.4.camel@finisterre.wolfsonmicro.main>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 12:14 -0700, Randy Dunlap wrote:


> When CONFIG_SPI is not enabled (so REGMAP_SPI is not enabled):
> (on i386 and x86_64)

> sound/built-in.o: In function `snd_soc_codec_set_cache_io':
> (.text+0x85635): undefined reference to `regmap_init_spi'

Fixed before you reported it by Axel.

