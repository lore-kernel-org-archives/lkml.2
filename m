Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2HHLDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 07:03:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2HHLDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 07:03:14 -0400
Date: Wed, 8 Aug 2012 04:00:59 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'John Stultz'" <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Sascha Hauer'" <kernel@pengutronix.de>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>
Subject: Re: [PATCH 2/9] ARM: plat-s3c24xx: Don't use FIQ_START
Message-ID: <20120808110058.GA22197@lizard>
References: <20120805230238.GA1663@lizard>
 <1344207819-3415-2-git-send-email-anton.vorontsov@linaro.org>
 <0af201cd7553$3346dd70$99d49850$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0af201cd7553$3346dd70$99d49850$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 07:47:26PM +0900, Kukjin Kim wrote:
> Anton Vorontsov wrote:
> > We're about to remove FIQ_START mess, so move the platform-specific
> > detail inside platform-specific s3c24xx_set_fiq().
> > 
> > Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks!

> BTW, how was going on the 'change FIQ_START to a variable' patch from Shawn
> Guo?
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-June/106486.html

It's in Linus' tree already. My patch set is just a next step in
the same direction.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
