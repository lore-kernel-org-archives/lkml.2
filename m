Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab0EFNmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 09:42:43 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:62299 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186Ab0EFNmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 09:42:42 -0400
Subject: Re: [PATCH RESEND] mc13783-regulator: fix vaild voltage range
 checking for mc13783_fixed_regulator_set_voltage
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <1273116816.26133.1.camel@mola>
References: <1273116816.26133.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 14:42:39 +0100
Message-ID: <1273153359.2992.38.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 11:33 +0800, Axel Lin wrote:
> In the case of "min_uV == max_uV == mc13783_regulators[id].voltages[0]",
> mc13783_fixed_regulator_set_voltage should return 0 instead of -EINVAL.
> 
> This patch also adds a missing ">" character for MODULE_AUTHOR, a trivial fix.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> ---
>  drivers/regulator/mc13783-regulator.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

