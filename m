Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1K1BB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 20:01:29 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:36865 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab1K1BB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 20:01:28 -0500
Subject: Re: [PATCH] rtc: convert drivers/rtc/* to use
 module_platform_driver()
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben@simtec.co.uk>,
        John Stultz <john.stultz@linaro.org>, rtc-linux@googlegroups.com
In-Reply-To: <1322238658.6445.1.camel@phoenix>
References: <1322238658.6445.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Mon, 28 Nov 2011 09:00:43 +0800
Message-ID: <1322442043.8661.2.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-26 at 00:30 +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/rtc/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Mike Frysinger <vapier.adi@gmail.com>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Ben Dooks <ben@simtec.co.uk>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

For rtc-puv3.c,
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Thanks,
Guan Xuetao

