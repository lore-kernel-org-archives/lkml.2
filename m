Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2JQNKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:10:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36448 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755859Ab2JQNKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:10:54 -0400
Date: Wed, 17 Oct 2012 22:10:48 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        fengguang.wu@intel.com, rdunlap@xenotime.net,
        gregkh@linuxfoundation.org, swarren@wwwdotorg.org
Subject: Re: [PATCH 1/1] regmap: select REGMAP if REGMAP_MMIO and REGMAP_IRQ
 enabled
Message-ID: <20121017131045.GN14199@opensource.wolfsonmicro.com>
References: <1350287425-19181-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350287425-19181-1-git-send-email-b29396@freescale.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 03:50:25PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> The regmap_mmio and regmap_irq depend on regmap core, if not select,
> we may not compile regmap core and meet compiling errors as follows
> if REGMAP_MMIO is selected by client drivers:

Applied, thanks.

Please use less random CC lists.
