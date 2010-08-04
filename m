Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab0HDIIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:08:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60635 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0HDIIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:08:12 -0400
Subject: Re: [PATCH] max8998: fix off-by-one value range checking
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20100804075025.GA22446@rakim.wolfsonmicro.main>
References: <1280903650.8393.1.camel@mola>
	 <20100804075025.GA22446@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 09:08:07 +0100
Message-ID: <1280909287.3065.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 08:50 +0100, Mark Brown wrote:
> On Wed, Aug 04, 2010 at 02:34:10PM +0800, Axel Lin wrote:
> > In max8998_list_voltage() and max8998_set_voltage(),
> > we use ldo as array index of ldo_voltage_map.
> > Thus the valid range should be 0 .. ARRAY_SIZE(ldo_voltage_map)-1.
> 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

