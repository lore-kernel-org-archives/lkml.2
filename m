Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767931Ab2KOOIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:08:15 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44430 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767820Ab2KOOIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:14 -0500
MIME-Version: 1.0
In-Reply-To: <1352795334-7406-5-git-send-email-peter.ujfalusi@ti.com>
References: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
	<1352795334-7406-5-git-send-email-peter.ujfalusi@ti.com>
Date: Thu, 15 Nov 2012 15:08:12 +0100
Message-ID: <CACRpkdYp_7Pe10Hj4mGGEEnS6xa45_UazLrz6J57Ch2KdLm8cg@mail.gmail.com>
Subject: Re: [PATCH 04/13] MFD/rtc/gpio: twl: No need to allocate bigger
 buffer for write
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tero Kristo <t-kristo@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 9:28 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> Since the twl-core has been converted to use regmap it is no longer needed
> to allocate bigger buffer for data when writing to twl.
>
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Alessandro Zummo <a.zummo@towertech.it>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess this will go through the MFD tree.

Yours,
Linus Walleij
