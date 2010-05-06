Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab0EFJsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:48:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58366 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751801Ab0EFJso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:48:44 -0400
Date: Thu, 6 May 2010 10:48:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH RESEND] mc13783-regulator: fix vaild voltage range
 checking for mc13783_fixed_regulator_set_voltage
Message-ID: <20100506094842.GA30491@rakim.wolfsonmicro.main>
References: <1273116816.26133.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273116816.26133.1.camel@mola>
X-Cookie: Do not stamp.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 11:33:36AM +0800, Axel Lin wrote:
> In the case of "min_uV == max_uV == mc13783_regulators[id].voltages[0]",
> mc13783_fixed_regulator_set_voltage should return 0 instead of -EINVAL.
> 
> This patch also adds a missing ">" character for MODULE_AUTHOR, a trivial fix.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Better to send two patches for two separate fixes, especially where
there's no overlap in the code.
