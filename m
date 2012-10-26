Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2JZHUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:20:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42589 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab2JZHUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:20:00 -0400
MIME-Version: 1.0
In-Reply-To: <1351088727-15257-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1351088727-15257-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Fri, 26 Oct 2012 09:19:59 +0200
Message-ID: <CACRpkdbVmjymkcH-Nsy38hKejMt0B=_mFRNHYN1ORsshAJxDog@mail.gmail.com>
Subject: Re: [RFC PATCH v2] gpiolib: add gpio get direction callback support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 4:25 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> Add .get_direction callback to gpio_chip. This allows gpiolib
> to check the current direction of a gpio.
> Used to show the correct gpio direction in sysfs and debug entries.
>
> If callback is not set then gpiolib will work as previously;
> e.g. guessing everything is input until a direction is set.
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

I buy into this concept.

Patch applied.

Unless Grant protests, it stays in.

Thanks for working on this!
Linus Walleij
