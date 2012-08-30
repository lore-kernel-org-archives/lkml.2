Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab2H3SOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:14:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49751 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab2H3SOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:14:05 -0400
Date: Thu, 30 Aug 2012 11:14:01 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Xiaofan Tian <tianxf@marvell.com>
Cc: linux-kernel@vger.kernel.org, Qing Xu <qingx@marvell.com>
Subject: Re: [PATCH] regmap-irq: Add mask invert flag for enable register
Message-ID: <20120830181400.GK4356@opensource.wolfsonmicro.com>
References: <1346317415-12276-1-git-send-email-tianxf@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346317415-12276-1-git-send-email-tianxf@marvell.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 05:03:35PM +0800, Xiaofan Tian wrote:
> Currently, regmap will write 1 to mask_base to mask
> an interrupt and write 0 to unmask it.

Applied, thanks.
