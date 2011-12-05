Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab1LEJxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:53:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59319 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1LEJxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:53:21 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] pcmcia: pxa: replace IRQ_GPIO() with gpio_to_irq()
Date: Mon, 5 Dec 2011 10:53:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Ian Molton <spyro@f2s.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-pcmcia@lists.infradead.org
References: <1323075548.20963.7.camel@phoenix> <CAMPhdO8F8QLjfeJReXSHgJNg+iaJ+CQ9i50ozsqAOiPWxhfwNA@mail.gmail.com>
In-Reply-To: <CAMPhdO8F8QLjfeJReXSHgJNg+iaJ+CQ9i50ozsqAOiPWxhfwNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112051053.17618.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Dec 5, 2011 at 4:59 PM, Axel Lin <axel.lin@gmail.com> wrote:
> > Since commit 6384fd "ARM: pxa: rename IRQ_GPIO to PXA_GPIO_TO_IRQ",
> > I got buid errors due to implicit declaration of function 'IRQ_GPIO'.
> > 
> > Use common gpio_to_irq() to replace machine dependant macro IRQ_GPIO().
> > 
> > Cc: Marek Vasut <marek.vasut@gmail.com>
> > Cc: Ian Molton <spyro@f2s.com>
> > Cc: Jonathan Cameron <jic23@cam.ac.uk>
> > Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
> > Cc: Eric Miao <eric.y.miao@gmail.com>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Looks fine to me.
> 
> Acked-by: Eric Miao <eric.y.miao@gmail.com>

I did a quick skim over the patch:

Acked-by: Marek Vasut <marek.vasut@gmail.com>
