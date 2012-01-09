Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2AIPCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:02:41 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55358 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755060Ab2AIPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:02:40 -0500
Date: Mon, 9 Jan 2012 23:02:25 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, vinod.koul@intel.com, eric.miao@linaro.org,
        kernel@pengutronix.de, dan.j.williams@intel.com, shawn.guo@linaro.org
Subject: Re: [PATCH v4 2/2] dma/imx-sdma: convert _raw_readl/_raw_writel to
 readl/writel
Message-ID: <20120109150222.GB2386@richard-laptop>
References: <1326033862-25351-1-git-send-email-richard.zhao@linaro.org>
 <1326033862-25351-3-git-send-email-richard.zhao@linaro.org>
 <20120109115143.GL21765@n2100.arm.linux.org.uk>
 <20120109142125.GA1854@richard-laptop>
 <20120109144627.GR21765@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109144627.GR21765@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 02:46:27PM +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 09, 2012 at 10:21:28PM +0800, Richard Zhao wrote:
> > Freescale power pc also has sdma, I guess we can use _relaxed till they
> > tend to use the same driver ( I don't know when).
> 
> The answer to that is to persuade powerpc to gain the _relaxed versions
> (which can simply call the non-relaxed versions as a first stab.)  They
> have the readx_relaxed() stuff already.
quite right.

Thanks
Richard
