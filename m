Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3ABGq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 01:46:27 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:57097 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3ABGq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 01:46:26 -0500
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E10E0C@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E10E0C@DQHE02.ent.ti.com>
Date: Wed, 2 Jan 2013 01:46:25 -0500
Message-ID: <CAHdPZaNA2UNrqKu0+ts4Z-aVLH=QpzhB4qUN6T37GaDUAXxejw@mail.gmail.com>
Subject: Re: [PATCH v4] rtc: add new lp8788 rtc driver
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 1:30 AM, Kim, Milo <Milo.Kim@ti.com> wrote:
> TI LP8788 PMU supports regulators, battery charger, RTC, ADC, backlight driver
> and current sinks.
> This patch enables LP8788 rtc module.
>
> Patch v4.
>  when alarm IRQ number is not specified, RTC_AIE_ON ioctl returns as -EIO
>  remove unnecessary platform data check routine
>  fix wrong parent device pointer in _probe(): use '&pdev->dev'
>  fix return value when rtc_device_register() gets failed: use PTR_ERR()
>
> Patch v3.
>  remove __devinit and __devexit
>  add weekday definition and comments
>
> Patch v2.
>  use irq domain for handling alarm IRQ
>  replace module_init() and module_exit() with module_platform_driver()
>  clean up code for _probe() and _remove()
>
> Patch v1.
>  initial patch
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/rtc/Kconfig      |    6 +
>  drivers/rtc/Makefile     |    1 +
>  drivers/rtc/rtc-lp8788.c |  344 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 351 insertions(+)
>  create mode 100644 drivers/rtc/rtc-lp8788.c

Thanks for taking care of the comments!
