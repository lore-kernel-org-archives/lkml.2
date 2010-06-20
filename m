Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0FTGc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 02:32:26 -0400
Received: from bamako.nerim.net ([62.4.17.28]:63270 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab0FTGcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 02:32:25 -0400
Date: Sun, 20 Jun 2010 08:32:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH v4] hwmon: Add JZ4740 ADC driver
Message-ID: <20100620083221.6738211e@hyperion.delvare>
In-Reply-To: <1276975978-25778-1-git-send-email-lars@metafoo.de>
References: <1276958820-8862-1-git-send-email-lars@metafoo.de>
	<1276975978-25778-1-git-send-email-lars@metafoo.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jun 2010 21:32:58 +0200, Lars-Peter Clausen wrote:
> This patch adds support for reading the ADCIN pin of ADC unit on JZ4740 SoCs.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: lm-sensors@lm-sensors.org
> 
> --
> Changes since v1
> - Move ADC core access synchronizing from the HWMON driver to a MFD driver. The
>   ADC driver now only reads the adcin value.
> 
> Changes since v2
>   - Add name sysfs attribute
>   - Report adcin in value in millivolts
> 
> Changes since v3
>   - Fix Kconfig entry
>   - Add include to completion.h
>   - Break overlong lines
>   - Use DEVICE_ATTR instead of SENSOR_DEVICE_ATTR for the adcin sys file.
> ---
>  drivers/hwmon/Kconfig        |   10 ++
>  drivers/hwmon/Makefile       |    1 +
>  drivers/hwmon/jz4740-hwmon.c |  226 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 237 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/jz4740-hwmon.c
> (...)

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
