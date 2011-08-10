Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab1HJF1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 01:27:16 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40429 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab1HJF1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 01:27:15 -0400
MIME-Version: 1.0
In-Reply-To: <1312948364-2587-3-git-send-email-lars@metafoo.de>
References: <1312948364-2587-1-git-send-email-lars@metafoo.de>
	<1312948364-2587-3-git-send-email-lars@metafoo.de>
Date: Wed, 10 Aug 2011 13:27:14 +0800
Message-ID: <CAHG8p1CuiJws=wSKrfAiY9E=rne=taPP-semYZQJWuHn19398w@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 3/4] ASoC: Blackfin: ADAU1373 eval board support
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Mike Frysinger <vapier.adi@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config SND_SOC_BFIN_EVAL_ADAU1373
> +       tristate "Support for the EVAL-ADAU1373 board on Blackfin eval boards"
> +       depends on SND_BF5XX_I2S
> +       select SND_BF5XX_SOC_I2S
> +       select SND_SOC_ADAU1373
> +       select I2C

Is it better to use depends on I2C?

> +       help
> +         Say Y if you want to add support for the Analog Devices EVAL-ADAU1373
> +         board connected to one of the Blackfin evaluation boards like the
> +         BF5XX-STAMP or BF5XX-EZKIT.
