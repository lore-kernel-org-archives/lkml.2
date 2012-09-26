Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2IZHBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:01:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61661 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab2IZHBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <1348559634-15337-1-git-send-email-stigge@antcom.de>
References: <1348559634-15337-1-git-send-email-stigge@antcom.de>
Date: Wed, 26 Sep 2012 09:01:49 +0200
Message-ID: <CACRpkdauqV8LwA=jRFUE1Dd7rJ_kLGMDr44Uv_6XMFBhe1b9-g@mail.gmail.com>
Subject: Re: [PATCH RESEND] gpio-lpc32xx: Fix value handling of gpio_direction_output()
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        aletes.xgr@gmail.com, linux-arm-kernel@lists.infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 9:53 AM, Roland Stigge <stigge@antcom.de> wrote:
> For GPIOs of gpio-lpc32xx, gpio_direction_output() ignores the value argument
> (initial value of output). This patch fixes this by setting the level
> accordingly.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>
> ---
> Applies to v3.6-rc7

I will attempt to funnel this to Torvalds today.

Thanks,
Linus Walleij
