Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1DROay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:30:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54878 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754697Ab1DROar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:30:47 -0400
Date: Mon, 18 Apr 2011 15:30:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH 14/14] regulator: 88pm8607: avoid to use constraint
 name in driver
Message-ID: <20110418143044.GF2466@opensource.wolfsonmicro.com>
References: <2011041801>
 <1303135451-26362-15-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303135451-26362-15-git-send-email-haojian.zhuang@marvell.com>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:04:11PM +0800, Haojian Zhuang wrote:
> Avoid to use constraint name in driver. So use driver_data instead to
> store regulator name in platform driver.

If this is something that's present in the current driver it should be
fixed for 2.6.39 so should be a patch at the start of the series which
can be applied separately to the others.

> +		/* pdata->driver_data stores the name of regulator */
> +		if (!strcmp(info->desc.name, pdata->driver_data))
>  			break;

Why not just use #defines in the header?  It'd be less error prone if
nothing else.
