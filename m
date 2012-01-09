Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2AIOqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:46:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50554 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab2AIOqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:46:35 -0500
Date: Mon, 9 Jan 2012 14:46:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, vinod.koul@intel.com, eric.miao@linaro.org,
        kernel@pengutronix.de, dan.j.williams@intel.com, shawn.guo@linaro.org
Subject: Re: [PATCH v4 2/2] dma/imx-sdma: convert _raw_readl/_raw_writel to
	readl/writel
Message-ID: <20120109144627.GR21765@n2100.arm.linux.org.uk>
References: <1326033862-25351-1-git-send-email-richard.zhao@linaro.org> <1326033862-25351-3-git-send-email-richard.zhao@linaro.org> <20120109115143.GL21765@n2100.arm.linux.org.uk> <20120109142125.GA1854@richard-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109142125.GA1854@richard-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:21:28PM +0800, Richard Zhao wrote:
> Freescale power pc also has sdma, I guess we can use _relaxed till they
> tend to use the same driver ( I don't know when).

The answer to that is to persuade powerpc to gain the _relaxed versions
(which can simply call the non-relaxed versions as a first stab.)  They
have the readx_relaxed() stuff already.
