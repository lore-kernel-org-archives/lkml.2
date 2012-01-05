Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab2AEJoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 04:44:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49290 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2AEJoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 04:44:03 -0500
Date: Thu, 5 Jan 2012 17:54:15 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Richard Zhao <richard.zhao@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        eric.miao@linaro.org, kernel@pengutronix.de, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/2] dma/imx-sdma: use writel to write register when
 enable a channel
Message-ID: <20120105095413.GD1729@S2101-09.ap.freescale.net>
References: <1325750362-22598-1-git-send-email-richard.zhao@linaro.org>
 <1325750362-22598-3-git-send-email-richard.zhao@linaro.org>
 <20120105092316.GB1729@S2101-09.ap.freescale.net>
 <20120105091904.GO2414@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105091904.GO2414@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 05:19:05PM +0800, Richard Zhao wrote:
> Russel mentioned that too. But I cannot understand.
> If CONFIG_ARM_DMA_MEM_BUFFERABLE, readl/writel always call rmb/wmb. Do
> we realy need it? It might affect performance.
> 
For safety, I think we need it.  The operations should be really fast.

-- 
Regards,
Shawn
