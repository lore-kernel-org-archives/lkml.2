Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0H0NEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:04:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53513 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab0H0NEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:04:31 -0400
Subject: Re: [PATCH] regulator: set max8998->dev to &pdev->dev.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20100827093028.GG24381@opensource.wolfsonmicro.com>
References: <1282898254.1971.4.camel@mola>
	 <20100827093028.GG24381@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 14:04:05 +0100
Message-ID: <1282914245.3025.29.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 10:30 +0100, Mark Brown wrote:
> On Fri, Aug 27, 2010 at 04:37:34PM +0800, Axel Lin wrote:
> > max8998->dev is NULL in current implementation, set it to &pdev->dev.
> > 
> > regulator_register() still return success if max8998->dev is NULL,
> > but rdev->dev.parent will be set to NULL which is incorrect.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> --
Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

