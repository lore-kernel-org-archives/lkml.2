Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1LXSyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 13:54:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49150 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745Ab1LXSyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 13:54:40 -0500
Date: Sat, 24 Dec 2011 18:54:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] mfd: Add s5m series irq driver
Message-ID: <20111224185438.GB10515@opensource.wolfsonmicro.com>
References: <1324628892-12170-1-git-send-email-sbkim73@samsung.com> <1324628892-12170-3-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324628892-12170-3-git-send-email-sbkim73@samsung.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 05:28:09PM +0900, Sangbeom Kim wrote:
> This patch support irq for s5m series.
> Basically, S5M8767 and S5M8763 irq can be handled by this patch.

This looks like it should be very straightforward to convert it to
regmap-irq (which is sitting in -next with a few users already) - it
should just be the data table defining the interrupts and that's that.
Certainly the code is liberally inspired by the same code that was
generalised to make regmap-irq.
