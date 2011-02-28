Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1B1Oyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:54:39 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57532 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab1B1Oyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:54:38 -0500
MIME-Version: 1.0
In-Reply-To: <1298377440-13032-1-git-send-email-daniel.willerud@stericsson.com>
References: <1298377440-13032-1-git-send-email-daniel.willerud@stericsson.com>
Date: Mon, 28 Feb 2011 15:54:37 +0100
Message-ID: <AANLkTikAV306-Cv9PS-nfft3BvWHaMrRG8g7h43OM0EE@mail.gmail.com>
Subject: Re: [PATCH] MFD: ab8500: New ab8500_gpadc APIs and reentrance
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Arun MURTHY <arun.murthy@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 1:24 PM, Daniel Willerud
<daniel.willerud@stericsson.com> wrote:

> Added ab8500_gpadc_get() API: A client do not need to be a ab8500 sub-device
> Added ab8500_gpadc_convert() API
> Added support for multiple ab8500-gpadc instances, driver is now reentrant
>
> Corrected regulator naming according to ste-next
>
> Signed-off-by: Daniel Willerud <daniel.willerud@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Acked-by: Mattias Wallin <mattias.wallin@stericsson.com>

Sam, are you happy with this patch?

I think it makes everyone happy inside ST-Ericsson and get
us in perfect sync with what we have internally. It'd be great to
have this queued for -next. It's a dependency to our battery
charging code which we will likely work on in the next (2.6.40)
merge window.

Yours,
Linus Walleij
