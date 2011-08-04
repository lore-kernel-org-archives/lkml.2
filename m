Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1HDMiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:38:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55253 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753374Ab1HDMiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:38:06 -0400
Date: Thu, 4 Aug 2011 21:27:27 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: tps65023: Added support for the similiar
 TPS65020 chip
Message-ID: <20110804122725.GE9959@opensource.wolfsonmicro.com>
References: <marcus.folkesson@gmail.com>
 <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
 <1312457632-27075-5-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312457632-27075-5-git-send-email-marcus.folkesson@gmail.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 01:33:52PM +0200, Marcus Folkesson wrote:
> Defines a new voltage-table and allows registering of the tps65020 device.
> 
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> +static struct tps_driver_data tps65020_drv_data = {
> +		.info = tps65020_regs,
> +		.core_regulator = TPS65023_DCDC_3,
> +};

but the indentation here is a bit odd, it's double indented.
