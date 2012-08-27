Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2H0XBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:01:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39515 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2H0XBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:01:53 -0400
MIME-Version: 1.0
In-Reply-To: <1345241877-16200-18-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
	<1345241877-16200-18-git-send-email-cheiny@synaptics.com>
Date: Mon, 27 Aug 2012 16:01:52 -0700
Message-ID: <CACRpkdYNUNmbMinzAth4ZBUojgTuKCvf1msuvDy3EK_3aQ9vRg@mail.gmail.com>
Subject: Re: [RFC PATCH 17/17] input: RMI4 F54 analog data reporting
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 3:17 PM, Christopher Heiny <cheiny@synaptics.com> wrote:

Verbose commit message.

> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

> +#include <linux/hrtimer.h>
> +#include <linux/kernel.h>
> +#include <linux/rmi.h>
> +#include <linux/slab.h>
> +#include <linux/version.h>
> +#include <linux/delay.h>

This is not using the existing in-kernel framework for ADC (which I think is
what you're doing), in this case use the IIO subsystem so consult
drivers/iio/adc and be inspired.

Just exposing a set of weird sysfs files to userspace is not proper.

Yours,
Linus Walleij
