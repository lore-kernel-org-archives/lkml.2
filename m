Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0IPNEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 09:04:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36162 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab0IPNEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 09:04:45 -0400
Subject: Re: [PATCH] Regulator: LP3972 PMIC regulator driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20100916105921.GD7837@rakim.wolfsonmicro.main>
References: <1284626929.12168.3.camel@mola>
	 <20100916105921.GD7837@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 14:04:37 +0100
Message-ID: <1284642277.21170.13.camel@vega>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 11:59 +0100, Mark Brown wrote:
> On Thu, Sep 16, 2010 at 04:48:49PM +0800, Axel Lin wrote:
> > This patch adds regulator drivers for National Semiconductors LP3972
> PMIC.
> > This LP3972 PMIC controller has 3 DC/DC voltage converters and 5 low
> drop-out
> > (LDO) regulators. LP3972 PMIC controller uses I2C interface.
> 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com> 

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

