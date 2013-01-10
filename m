Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3AJKlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:41:19 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:65160 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3AJKlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:41:16 -0500
MIME-Version: 1.0
In-Reply-To: <1355996651-17805-1-git-send-email-peter.ujfalusi@ti.com>
References: <1355996651-17805-1-git-send-email-peter.ujfalusi@ti.com>
Date: Thu, 10 Jan 2013 11:41:15 +0100
Message-ID: <CACRpkdZK8AA-osijVpbp7U-Wv0XUAVxDPQ3zxfCqWYb6WKjmwQ@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: twl4030: Cache the direction and output states
 in private data
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 10:44 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> Use more coherent locking in the driver. Use bitfield to store the GPIO
> direction and if the pin is configured as output store the status also in a
> bitfiled.
> In this way we can just look at these bitfields when we need information
> about the pin status and only reach out to the chip when it is needed.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Hi Grant,
>
> Changes sicne v2:
> - Fixed the mutex_unlock found by Michael.
> - Removed the debug prints addedd by v2 patch (remains from debugging)
> - Removed one blank line between includes and the first comment section.

Sorry Peter this must have been missed somehow.

This does not apply to the current v3.8-rc3, could you respin
this on top of Torvalds' tree?

Yours,
Linus Walleij
