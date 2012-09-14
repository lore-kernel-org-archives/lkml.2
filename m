Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200Ab2INWiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:38:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50635 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135Ab2INWiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:38:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6835"; a="237064407"
Message-ID: <5053B1C9.10103@codeaurora.org>
Date: Fri, 14 Sep 2012 15:38:01 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 12/24] ARM: msm: use __iomem pointers for MMIO
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-13-git-send-email-arnd@arndb.de>
In-Reply-To: <1347658492-11608-13-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/12 14:34, Arnd Bergmann wrote:
> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.
>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Cc: Bryan Huntsman <bryanh@codeaurora.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I was going to send this patch out today. Thanks.

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

