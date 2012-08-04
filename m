Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2HDXKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 19:10:35 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62423 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2HDXKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 19:10:32 -0400
MIME-Version: 1.0
In-Reply-To: <1343126116.6033.1.camel@phoenix>
References: <1343126116.6033.1.camel@phoenix>
Date: Sun, 5 Aug 2012 01:10:32 +0200
Message-ID: <CACRpkdabQsJ9qQRHi4HRVLKZ81MeNyTRGLvXjGmngn83W9Qqjg@mail.gmail.com>
Subject: Re: [PATCH] gpio: msic: Fix calculating register address in msic_gpio_to_oreg()
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:35 PM, Axel Lin <axel.lin@gmail.com> wrote:

> In the case offset is 20 ... 23, the equation to get the register should be:
>         INTEL_MSIC_GPIO1HV0CTLO - offset + 20
>
> With above equation, we can get below mapping between offset and the register:
>         offset is 20: INTEL_MSIC_GPIO1HV0CTLO
>         offset is 21: INTEL_MSIC_GPIO1HV1CTLO
>         offset is 22: INTEL_MSIC_GPIO1HV2CTLO
>         offset is 23: INTEL_MSIC_GPIO1HV3CTLO
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks, applied to my fixes branch with Mathias' ACK.

Yours,
Linus Walleij
