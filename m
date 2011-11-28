Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1K1LH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:07:29 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:50284 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab1K1LH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:07:28 -0500
Message-ID: <4ED36B21.8000108@stericsson.com>
Date: Mon, 28 Nov 2011 12:06:09 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben@simtec.co.uk>,
        John Stultz <john.stultz@linaro.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH] rtc: convert drivers/rtc/* to use module_platform_driver()
References: <1322238658.6445.1.camel@phoenix>
In-Reply-To: <1322238658.6445.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 05:30 PM, Axel Lin wrote:
> This patch converts the drivers in drivers/rtc/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: Haojian Zhuang<haojian.zhuang@marvell.com>
> Cc: Alessandro Zummo<a.zummo@towertech.it>
> Cc: Srinidhi Kasagar<srinidhi.kasagar@stericsson.com>
> Cc: Linus Walleij<linus.walleij@stericsson.com>
> Cc: Mike Frysinger<vapier.adi@gmail.com>
> Cc: Guan Xuetao<gxt@mprc.pku.edu.cn>
> Cc: Mark Brown<broonie@opensource.wolfsonmicro.com>
> Cc: Lars-Peter Clausen<lars@metafoo.de>
> Cc: Ben Dooks<ben@simtec.co.uk>
> Cc: John Stultz<john.stultz@linaro.org>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
>    

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Axel,
Linus Walleij
