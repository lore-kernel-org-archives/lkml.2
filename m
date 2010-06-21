Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab0FURvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:51:04 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41487 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab0FURvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:51:00 -0400
Subject: Re: [PATCH v3] drivers: regulator: add Maxim 8998 driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com
In-Reply-To: <1276671856-18902-1-git-send-email-m.szyprowski@samsung.com>
References: <1276671856-18902-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 18:50:58 +0100
Message-ID: <1277142658.3288.46.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 09:04 +0200, Marek Szyprowski wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> This patch adds voltage regulator driver for Maxim 8998 chip. This chip
> is used on Samsung Aquila and GONI boards and provides following
> functionalities:
> - 4 BUCK voltage converters, 17 LDO power regulators and 5 other power
>   controllers
> - battery charger
> 
> This patch adds basic driver for voltage regulators and MAX 8998 MFD core.
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> ---
> 
> Changes sinve V2:
> - moved max8998_{read,write,update}_reg function to
>   include/linux/mfd/max8998-private.h
> - removed max8998-rtc definition (rtc subfunction uses different i2c id
>   (mfd functionality is still required for battery charger driver)
> - added iolock mutex to serialize register access correctly
> 
> Changes since V1:
> - converted to MFD framework (for future extensions with RTC and battery
>   charger drivers)
> - removed i2c register cache
> - removed dummy irq support (gpio keys will be used for setting irq_wake)
> - removed static voltage map tables
> - introduced atomic register update io function
> - other code cleanup suggested by Mark Brown

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

