Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab2KELxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:53:18 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64378 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2KELxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:53:16 -0500
MIME-Version: 1.0
In-Reply-To: <1351928793-14375-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
	<1351928793-14375-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Mon, 5 Nov 2012 12:53:14 +0100
Message-ID: <CACRpkdYGbNCzV7QOURcEzhrNWv=kbWq+r3i66GtC75Aytso5rw@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 3, 2012 at 8:46 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> +/**
> + * acpi_get_gpio() - Translate ACPI GPIO pin to GPIO number usable with GPIO API
> + * @path:      ACPI GPIO controller full path name, (e.g. "\\_SB.GPO1")
> + * @pin:       ACPI GPIO pin number (0-based, controller-relative)
> + *
> + * Returns GPIO number to use with Linux generic GPIO API, or errno error value
> + */

So by just looking at that we can see that this is yet another
instance of papering
over the fact that the Linux GPIO numbers are global to the kernel and not
per-chip, as would be preferred.

Can you please contribute to the parallel discussion on how to get rid of
the global GPIO numberspace, thread named:
"How about a gpio_get(device *, char *) function?"

Yours,
Linus Walleij
