Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab2IOFQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 01:16:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64721 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2IOFQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 01:16:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6835"; a="237152262"
Date: Fri, 14 Sep 2012 22:16:02 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 12/24] ARM: msm: use __iomem pointers for MMIO
Message-ID: <20120915051602.GA7930@codeaurora.org>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
 <1347658492-11608-13-git-send-email-arnd@arndb.de>
 <5053B1C9.10103@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5053B1C9.10103@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 03:38:01PM -0700, Stephen Boyd wrote:
> On 09/14/12 14:34, Arnd Bergmann wrote:
> > ARM is moving to stricter checks on readl/write functions,
> > so we need to use the correct types everywhere.
> >
> > Cc: David Brown <davidb@codeaurora.org>
> > Cc: Daniel Walker <dwalker@fifo99.com>
> > Cc: Bryan Huntsman <bryanh@codeaurora.org>
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> I was going to send this patch out today. Thanks.
> 
> Acked-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: David Brown <davidb@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
