Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab2DJIGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:06:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40754 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab2DJIG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:06:27 -0400
MIME-Version: 1.0
In-Reply-To: <1334036844.15859.1.camel@phoenix>
References: <1334036844.15859.1.camel@phoenix>
Date: Tue, 10 Apr 2012 10:06:26 +0200
Message-ID: <CACRpkdbKw9iyXKeVLi4Xc78tEiFE3bnvwPnzvRoLcys-5cpT0g@mail.gmail.com>
Subject: Re: [PATCH 1/3] regulator: Fix build error for ab8500
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 7:47 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Fix below build errors which is introduced by commit c172708
> "regulator: core: Use a struct to pass in regulator runtime configuration".
>
>  CC      drivers/regulator/ab8500.o
> drivers/regulator/ab8500.c: In function 'ab8500_regulator_probe':
> drivers/regulator/ab8500.c:783: error: invalid type argument of '->' (have 'struct regulator_config')
> drivers/regulator/ab8500.c:784: error: invalid type argument of '->' (have 'struct regulator_config')
> drivers/regulator/ab8500.c:785: error: invalid type argument of '->' (have 'struct regulator_config')
> make[2]: *** [drivers/regulator/ab8500.o] Error 1
> make[1]: *** [drivers/regulator] Error 2
> make: *** [drivers] Error 2
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Axel,
Linus Walleij
