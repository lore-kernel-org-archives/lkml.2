Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab0FPUQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:16:54 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39110 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220Ab0FPUQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:16:51 -0400
Subject: Re: [PATCH v3] drivers: regulator: add Maxim 8998 driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20100616143041.GC24491@rakim.wolfsonmicro.main>
References: <1276671856-18902-1-git-send-email-m.szyprowski@samsung.com>
	 <20100616143041.GC24491@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 21:16:43 +0100
Message-ID: <1276719403.3028.50.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 15:30 +0100, Mark Brown wrote:
> On Wed, Jun 16, 2010 at 09:04:16AM +0200, Marek Szyprowski wrote:
> > From: Kyungmin Park <kyungmin.park@samsung.com>
> > 
> > This patch adds voltage regulator driver for Maxim 8998 chip. This chip
> > is used on Samsung Aquila and GONI boards and provides following
> > functionalities:
> > - 4 BUCK voltage converters, 17 LDO power regulators and 5 other power
> >   controllers
> > - battery charger
> > 
> > This patch adds basic driver for voltage regulators and MAX 8998 MFD core.
> > 
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Looks good!
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Samuel, I can take the whole patch via regulator if necessary (providing
I have your SoB for the mfd part).

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

