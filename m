Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0IEIsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 04:48:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46542 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752693Ab0IEIsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 04:48:36 -0400
Date: Sun, 5 Sep 2010 09:48:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: Re: [PATCH] regulator: ab8500 - fix off-by-one value range
	checking for selector
Message-ID: <20100905084834.GC24817@opensource.wolfsonmicro.com>
References: <1283612801.2430.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283612801.2430.1.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 11:06:41PM +0800, Axel Lin wrote:
> selector is used as array index of info->supported_voltages
> Thus the valid value range should be 0 .. info->voltages_len -1
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
