Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab2JCVyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:54:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38922 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2JCVyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:54:44 -0400
MIME-Version: 1.0
In-Reply-To: <20121003173603.GG4360@opensource.wolfsonmicro.com>
References: <1349284019-31571-1-git-send-email-festevam@gmail.com>
	<20121003173603.GG4360@opensource.wolfsonmicro.com>
Date: Wed, 3 Oct 2012 18:54:42 -0300
Message-ID: <CAOMZO5AaQYLhmWnSnRQhdOEcedJPng8MGK1tTNQBxSLxVccRgw@mail.gmail.com>
Subject: Re: [RFC 1/3] mfd: da9052-core: Use regmap_irq_get_virq() and fix the probe
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        arnd@arndb.de, kernel@pengutronix.de, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 2:36 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> I still don't understand what on earth this is doing, as far as I can
> tell there's only one domain in the device so you're not distrubting
> anything between domains and there's as many interrupts in this domain
> as there are in the domain allocated by regmap which is even odder.

Thanks for your clarification, Mark. I fixed it and managed to get
touchscreen to work now.

Will submit the patches shortly.

Thanks,

Fabio Estevam
