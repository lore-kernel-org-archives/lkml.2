Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252Ab0HFL3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 07:29:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33361 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752510Ab0HFL3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 07:29:02 -0400
Date: Fri, 6 Aug 2010 12:29:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] regulator: max8660 - fix a memory leak in
 max8660_remove()
Message-ID: <20100806112900.GG398@rakim.wolfsonmicro.main>
References: <1281072927.24426.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281072927.24426.5.camel@mola>
X-Cookie: "Pok pok pok, P'kok!"
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 01:35:27PM +0800, Axel Lin wrote:
> In max8660_probe(), we allocate memory for max660.
> In max8660_remove(), current implementation only free rdev
> which is a member of struct max8660.
> Thus, there is a small memory leak when we unload the module.
> 
> This patch fixes the memory leak by passing max660 to i2c clientdata,
> and properly kfree(max8660) in max8660_remove().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
