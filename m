Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0ECBTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 21:19:34 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60269 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0ECBTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 21:19:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5970"; a="40248941"
Subject: Re: [PATCH] arm/mach-msm: Add CONFIG conditional for board-trout
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Peter Huewe <PeterHuewe@gmx.de>, David Brown <davidb@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <20100501101442.GH12172@n2100.arm.linux.org.uk>
References: <201004290241.23068.PeterHuewe@gmx.de>
	 <20100501101442.GH12172@n2100.arm.linux.org.uk>
Content-Type: text/plain
Date: Sun, 02 May 2010 07:56:10 -0700
Message-Id: <1272812170.23015.1.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-01 at 11:14 +0100, Russell King - ARM Linux wrote:
> On Thu, Apr 29, 2010 at 02:41:22AM +0200, Peter Huewe wrote:
> > From: Peter Huewe <peterhuewe@gmx.de>
> > 
> > This patch adds a conditional for CONFIG_MSM_DEBUG_UART to prevent a
> > build failure[1], this is done the same way as for every board in mach-msm.
> > 
> > References:
> > [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2448102/
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Who's going to deal with getting this patch upstream?

I am .. I have a similar patch in my next tree already.

Daniel

