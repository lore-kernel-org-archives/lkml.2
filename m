Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0JVGAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 02:00:17 -0400
Received: from mail.perches.com ([173.55.12.10]:3505 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab0JVGAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 02:00:15 -0400
Subject: Re: [PATCH v4] Topcliff: Update PCH_GPIO driver to 2.6.35
From: Joe Perches <joe@perches.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com, yong.y.wang@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
In-Reply-To: <4CC1267D.50301@dsn.okisemi.com>
References: <4CC1267D.50301@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 23:00:12 -0700
Message-ID: <1287727212.28393.1.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 14:51 +0900, Tomoya MORINAGA wrote:

Just trivia:

> diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
[]
> +static const struct pci_device_id pch_gpio_pcidev_id[] = {
> +	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803)},
> +	{0,}
> +};

DEFINE_PCI_DEVICE_TABLE


