Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1HOXlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:41:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52812 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751807Ab1HOXlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:41:15 -0400
Date: Tue, 16 Aug 2011 08:41:08 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regmap: using module facilities requires module.h
Message-ID: <20110815234106.GB14003@opensource.wolfsonmicro.com>
References: <20110816093606.a764b904550c84f7db4c1b2d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816093606.a764b904550c84f7db4c1b2d@canb.auug.org.au>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 09:36:06AM +1000, Stephen Rothwell wrote:
> Commit b33f9cbd67ba ("regmap: Specify a module license") added a
> MODULES_LICENSE to this file without adding an include of module.h.
> module.h should ahve been included anyway, since this file has
> EXPORT_SYMBOLs as well.   With the pending module.h spliit up, this would
> probably caused build problems.

Applied with a few typo fixes to the commit log, thanks.
