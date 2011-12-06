Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab1LFF32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 00:29:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33491 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1LFF30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 00:29:26 -0500
Date: Mon, 5 Dec 2011 21:29:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: zylonite-wm97xx - replace IRQ_GPIO() with
 gpio_to_irq()
Message-ID: <20111206052920.GA21617@core.coreip.homeip.net>
References: <1323083592.6763.5.camel@phoenix>
 <20111205115054.GH11150@opensource.wolfsonmicro.com>
 <CAN1soZwuTqiPC1wof6PfeLb3zhzm+w1WSUsJJQWmCS-3ECxTJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZwuTqiPC1wof6PfeLb3zhzm+w1WSUsJJQWmCS-3ECxTJw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 12:58:36PM +0800, Haojian Zhuang wrote:
> On Mon, Dec 5, 2011 at 7:50 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Mon, Dec 05, 2011 at 07:13:12PM +0800, Axel Lin wrote:
> >> Since commit 6384fd "ARM: pxa: rename IRQ_GPIO to PXA_GPIO_TO_IRQ",
> >> I got below buid errors due to implicit declaration of function 'IRQ_GPIO'.
> >
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >
> > I guess that for bisection this should go via Eric's tree as it
> > introduced the issue.
> > --
> Sure. We'll handle it.
> 

Thanks!

-- 
Dmitry
