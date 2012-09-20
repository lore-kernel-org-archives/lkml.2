Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2ITGpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:45:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47403 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2ITGpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:45:52 -0400
MIME-Version: 1.0
In-Reply-To: <1348038044-1790-5-git-send-email-sboyd@codeaurora.org>
References: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
	<1348038044-1790-5-git-send-email-sboyd@codeaurora.org>
Date: Thu, 20 Sep 2012 08:45:50 +0200
Message-ID: <CACRpkdZZ4y2TpkDAgxp38hLbsvxV3hqQ0PRjEQ1s+CXuq8TVQg@mail.gmail.com>
Subject: Re: [PATCH 4/5] gpio: Make gpio-msm-v1 into a platform driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 9:00 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> Doing this removes the dependence of this driver on the
> msm_iomap.h and cpu.h mach include headers provied by MSM. This
> is necessary to support single zImage work in the future and
> allows us to remove cpu.h entirely and brings us closer to
> removing msm_iomap.h.
>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Rohit Vaswani <rvaswani@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

This must be encouraged:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Stephen, do you have a mainline-based kernel tree that can boot
on my DragonBoard? It's just sitting idle here... I pushed David
in the past, just naggin'...

Yours,
Linus Walleij
