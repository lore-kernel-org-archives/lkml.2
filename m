Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab2DKIjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 04:39:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41044 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2DKIjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 04:39:08 -0400
MIME-Version: 1.0
In-Reply-To: <1334091089-10138-3-git-send-email-lars@metafoo.de>
References: <1334091089-10138-1-git-send-email-lars@metafoo.de>
	<1334091089-10138-3-git-send-email-lars@metafoo.de>
Date: Wed, 11 Apr 2012 10:39:07 +0200
Message-ID: <CACRpkdZOWWpgoFWYtU4DpLbVGCMRrF+cNLo-m1S2t2Y6xc=YJA@mail.gmail.com>
Subject: Re: [PATCH 3/4] mfd: Remove redundant spi driver bus initialization
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 10:51 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:

> In ancient times it was necessary to manually initialize the bus field of an
> spi_driver to spi_bus_type. These days this is done in spi_driver_register() so
> we can drop the manual assignment.
>
> The patch was generated using the following coccinelle semantic patch:
> // <smpl>
> @@
> identifier _driver;
> @@
> struct spi_driver _driver = {
>    .driver = {
> -           .bus = &spi_bus_type,
>    },
> };
> // </smpl>
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Cc: Linus Walleij <linus.walleij@stericsson.com>

Looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
