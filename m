Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2K1J6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:58:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33895 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2K1J6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:58:38 -0500
Message-ID: <50B5E03E.2080308@ti.com>
Date: Wed, 28 Nov 2012 09:58:22 +0000
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Oskar Schirmer <oskar@scara.com>
CC: Wolfram Sang <w.sang@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Zeng Zhaoming <zengzm.kernel@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] sound/sgtl5000: fix initial setting for DAC data source
References: <1354094459-32466-1-git-send-email-oskar@scara.com>
In-Reply-To: <1354094459-32466-1-git-send-email-oskar@scara.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/11/12 09:20, Oskar Schirmer wrote:
> According to documentation bit 3:2 in register SSS_CTRL are
> reserved and zero, so the setting of 0x0008 does not make much sense.
> Instead, bit 4 should be set as is with power up, to reflect
> routing of I2S_IN to DAC correctly.
>
> Looks much like an off by one error.

Could you resend this to alsa-devel and CC maintainers.

Thanks

Liam

