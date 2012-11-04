Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2KDS3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 13:29:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37387 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2KDS3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 13:29:12 -0500
MIME-Version: 1.0
In-Reply-To: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Sun, 4 Nov 2012 19:29:10 +0100
Message-ID: <CACRpkdb0jmiBBi+W0U7h5PfVF-kYP+Ui-nOzWxBazMHxupruwA@mail.gmail.com>
Subject: Re: [PATCH 0/3] ACPI 5 support for GPIO, SPI and I2C
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 3, 2012 at 8:46 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> With ACPI 5 we can now describe how devices are connected to their bus
> using new resources: SPISerialBus and I2CSerialBus. Also it is now possible
> to add GPIO connections for the devices with the help of GpioIO and GpioInt
> resources.
>
> This series adds support for these new resources.

I would very much like Grant to review and merge these patches, since he
is way more familiar with these concepts than me, but I'll have a quick
glance for syntax and semantics...

Yours,
Linus Walleij
