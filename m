Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1LELu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:50:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54453 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756115Ab1LELu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:50:57 -0500
Date: Mon, 5 Dec 2011 11:50:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: zylonite-wm97xx - replace IRQ_GPIO() with
 gpio_to_irq()
Message-ID: <20111205115054.GH11150@opensource.wolfsonmicro.com>
References: <1323083592.6763.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323083592.6763.5.camel@phoenix>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 07:13:12PM +0800, Axel Lin wrote:
> Since commit 6384fd "ARM: pxa: rename IRQ_GPIO to PXA_GPIO_TO_IRQ",
> I got below buid errors due to implicit declaration of function 'IRQ_GPIO'.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

I guess that for bisection this should go via Eric's tree as it
introduced the issue.
