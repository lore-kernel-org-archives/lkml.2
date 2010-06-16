Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab0FPOao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:30:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43659 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753802Ab0FPOan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:30:43 -0400
Date: Wed, 16 Jun 2010 15:30:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH v3] drivers: regulator: add Maxim 8998 driver
Message-ID: <20100616143041.GC24491@rakim.wolfsonmicro.main>
References: <1276671856-18902-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276671856-18902-1-git-send-email-m.szyprowski@samsung.com>
X-Cookie: Eureka!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 09:04:16AM +0200, Marek Szyprowski wrote:
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

Looks good!

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
