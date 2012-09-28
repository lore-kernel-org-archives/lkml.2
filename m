Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2I1Kpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:45:44 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49364 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab2I1Kpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:45:42 -0400
MIME-Version: 1.0
In-Reply-To: <201209280642.05747.arnd@arndb.de>
References: <1348797458-2562-1-git-send-email-festevam@gmail.com>
	<201209280642.05747.arnd@arndb.de>
Date: Fri, 28 Sep 2012 07:45:42 -0300
Message-ID: <CAOMZO5BChG==wddh6Qb0LuShoRKf3VoLppJvY43ifL6Vf1ft0w@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: da9052-core: Use regmap_irq_get_virq() and fix
 the probe
From: Fabio Estevam <festevam@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com, marex@denx.de,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Sep 28, 2012 at 3:42 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> This looks good.
>
>> I also plan to convert the other da9052 drivers to use regmap_irq_get_virq().
>
> Ok, I think they have to be submitted together though, because otherwise
> the other drivers are more broken now.

Yes, makes sense. Will convert the others and submit the patches altogether.

Do you think I should also remove the "pdata" references, ie, let the
driver be dt-only?

I do not see any users for the da9052 drivers, except for mx53qsb,
which I added two days ago.

Regards,

Fabio Estevam
