Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2JILhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 07:37:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37860 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2JILhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 07:37:38 -0400
Message-ID: <50740C6D.7070906@ti.com>
Date: Tue, 9 Oct 2012 17:07:17 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: <spi-devel-general@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <grant.likely@secretlab.ca>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] spi:clk: preparation for switch to common clock framework
References: <1347900122-25101-1-git-send-email-m-karicheri2@ti.com> <1347900122-25101-2-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1347900122-25101-2-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/2012 10:12 PM, Murali Karicheri wrote:
> As a first step towards migrating davinci platforms to use common clock
> framework, replace all instances of clk_enable() with clk_prepare_enable()
> and clk_disable() with clk_disable_unprepare(). Until the platform is
> switched to use the CONFIG_HAVE_CLK_PREPARE Kconfig variable, this just
> adds a might_sleep() call and would work without any issues.
> 
> This will make it easy later to switch to common clk based implementation
> of clk driver from DaVinci specific driver.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Reviewed-by: Mike Turquette <mturquette@linaro.org>

This patch had to be applied manually and with some fuzz when I applied
it to latest linus/master. There were no conflicts though and once I
applied it, I was able to test SPI flash on DA850 EVM successfully using it.

Acked-by: Sekhar Nori <nsekhar@ti.com>

I am hoping this patch can still go in v3.7. I realize we are in the
middle of the merge window though.

Thanks,
Sekhar
