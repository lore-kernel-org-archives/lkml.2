Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0HZSiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:38:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49026 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753536Ab0HZSiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:38:51 -0400
Date: Thu, 26 Aug 2010 19:38:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Add generic driver for simple memory mapped
	controllers
Message-ID: <20100826183850.GB24381@opensource.wolfsonmicro.com>
References: <20100825194249.GA453@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825194249.GA453@oksana.dev.rtsoft.ru>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 11:42:49PM +0400, Anton Vorontsov wrote:

> +	res_dat = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res_dat)
> +		return -EINVAL;

I'd suggest naming these resources rather than grabbing by number,
that'll make it easier to plumb the machine driver side in since you
don't have to remember which number corresponds to which function.
