Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2JPFgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:36:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48068 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491Ab2JPFgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:36:10 -0400
Date: Tue, 16 Oct 2012 14:36:01 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 04/10] ASoC: imx: Don't use {en,dis}able_fiq() calls
Message-ID: <20121016053559.GE8670@opensource.wolfsonmicro.com>
References: <20121015214954.GA3352@lizard>
 <1350337894-9744-4-git-send-email-anton.vorontsov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350337894-9744-4-git-send-email-anton.vorontsov@linaro.org>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 02:51:28PM -0700, Anton Vorontsov wrote:
> The driver uses platform-specific mxc_set_irq_fiq() with the VIRQ cookie
> passed to it, so it's pretty clear that the driver is absolutely sure
> that the FIQ is routed via platform-specific IC, and that the cookie can
> be used to mask/unmask FIQs. So, let's switch to the genirq routines,
> since we're about to remove FIQ-specific variants.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
