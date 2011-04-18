Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1DRO3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:29:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60489 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752575Ab1DRO26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:28:58 -0400
Date: Mon, 18 Apr 2011 15:28:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH 13/14] regulator: check name in initialization of
 max8925
Message-ID: <20110418142855.GE2466@opensource.wolfsonmicro.com>
References: <2011041801>
 <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:04:10PM +0800, Haojian Zhuang wrote:
> Check name in initialization of max8925 regulator driver.

What name are we checking and why do we need to check it?  I've no idea
what the patch is supposed to do which makes it hard to review.

> +++ b/drivers/regulator/max8925-regulator.c
> @@ -174,7 +174,7 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
>  #define MAX8925_SDV(_id, min, max, step)			\
>  {								\
>  	.desc	= {						\
> -		.name	= "SDV" #_id,				\
> +		.name	= "SD" #_id,				\

The above isn't obviously correct - it changes the name that's assigned
from matching the macro used to something different.
