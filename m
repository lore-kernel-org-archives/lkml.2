Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934827Ab0GOVRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 17:17:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934814Ab0GOVRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 17:17:12 -0400
Date: Thu, 15 Jul 2010 14:16:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH v6] MMC: Add JZ4740 mmc driver
Message-Id: <20100715141653.1c0b6a8d.akpm@linux-foundation.org>
In-Reply-To: <1279227964-17801-1-git-send-email-lars@metafoo.de>
References: <1278973245-25451-1-git-send-email-lars@metafoo.de>
	<1279227964-17801-1-git-send-email-lars@metafoo.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 23:06:04 +0200
Lars-Peter Clausen <lars@metafoo.de> wrote:

> This patch adds support for the mmc controller on JZ4740 SoCs.
> 
>
> ...
>
> +		if (gpio_is_valid(host->pdata->gpio_power))
> +			gpio_set_value(host->pdata->gpio_power,
> +					!host->pdata->power_active_low);
>
> ...
>

Should this driver have a `depends on GPIOLIB' in Kconfig?
