Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2KLOwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:52:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45107 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2KLOwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:52:23 -0500
Message-ID: <50A10D22.9050103@ti.com>
Date: Mon, 12 Nov 2012 15:52:18 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/6] MFD: twl6040: Conversion to use regmap_irq
References: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 10/11/2012 01:55 PM, Peter Ujfalusi wrote:
> Hello,
> 
> This series will convert the twl6040 MFD core driver to use regmap_irq instead
> of the custom interrupt code it used. In this way considerable amount of code
> can be removed and we are going to use common, well tested code for the interrupt
> dispatch.
> 
> The series is for 3.8.

Did you had time to look at this series?
I can resend it if it is better for you.

Regards,
Péter

> 
> Regards,
> Peter
> ---
> Peter Ujfalusi (6):
>   MFD: twl6040: Fix typo for power on failure
>   MFD: twl6040: Remove unused parameter for
>     twl6040_power_up_completion()
>   MFD: twl6040: Restructure power up and down code
>   MFD: twl6040: Correct Ready and Thermal interrupt handling
>   MFD: twl6040: Convert to use regmap_irq
>   MFD: twl6040: Rename the core driver
> 
>  drivers/mfd/Kconfig                       |   4 +-
>  drivers/mfd/Makefile                      |   2 +-
>  drivers/mfd/twl6040-irq.c                 | 205 ------------------------------
>  drivers/mfd/{twl6040-core.c => twl6040.c} | 137 ++++++++++++--------
>  include/linux/mfd/twl6040.h               |  10 +-
>  5 files changed, 92 insertions(+), 266 deletions(-)
>  delete mode 100644 drivers/mfd/twl6040-irq.c
>  rename drivers/mfd/{twl6040-core.c => twl6040.c} (84%)
> 
