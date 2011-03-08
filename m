Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1CHXYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:24:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40475 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756264Ab1CHXYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:24:00 -0500
Date: Tue, 8 Mar 2011 23:24:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, dmitry.torokhov@gmail.com, dtor@mail.ru,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: adopt mfd_data in 88pm860x regulator
Message-ID: <20110308232419.GA2717@opensource.wolfsonmicro.com>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 11:43:11PM +0800, Haojian Zhuang wrote:
> Copy 88pm860x platform data into different mfd_data structure for
> regulator driver. So move the identification of device node from
> regulator driver to mfd driver.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but if there's any in-tree users of the device I'd expect they need
their platform data updated?
