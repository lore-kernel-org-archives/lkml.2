Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab2I1Phi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:37:38 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43997 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473Ab2I1Phg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:37:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120928142924.GA22101@opensource.wolfsonmicro.com>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com>
	<20120928104944.GB30869@opensource.wolfsonmicro.com>
	<5065B534.7040602@freescale.com>
	<20120928142924.GA22101@opensource.wolfsonmicro.com>
Date: Fri, 28 Sep 2012 12:37:35 -0300
Message-ID: <CAOMZO5DgOjs06BJZWsEay-jP5pjzMNTZTZnvAvzAd-JD9kqs1g@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: da9052-core: Use regmap_irq_get_virq() and fix
 the probe
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, sameo@linux.intel.com,
        Marek Vasut <marex@denx.de>, ashish.jangam@kpitcummins.com,
        dchen@diasemi.com, arnd@arndb.de, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:29 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> No, this doesn't support linear domains, if you're going to do this it'd
> be better to just leave it as irq_base though as discussed that's not
> ideal.  When I've done these conversions I've just done the virq
> conversion at every use.

Ok, so if I understand you correctly you suggest that Samuel applies
the v1 of the patch:
https://lkml.org/lkml/2012/9/26/551

Please confirm.

Regards,

Fabio Estevam
