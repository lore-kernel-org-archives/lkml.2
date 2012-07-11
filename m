Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab2GKVvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:51:31 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54927 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab2GKVv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:51:29 -0400
MIME-Version: 1.0
In-Reply-To: <1341997995-14020-2-git-send-email-tarun.kanti@ti.com>
References: <1341997995-14020-1-git-send-email-tarun.kanti@ti.com>
	<1341997995-14020-2-git-send-email-tarun.kanti@ti.com>
Date: Wed, 11 Jul 2012 23:51:28 +0200
Message-ID: <CACRpkdYdtrAu-GX4F6iv_3VM4DrTAU48ch63SotLybfi8oLffQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio/omap: move bank->dbck initialization to omap_gpio_mod_init()
From: Linus Walleij <linus.walleij@linaro.org>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 11:13 AM, Tarun Kanti DebBarma
<tarun.kanti@ti.com> wrote:

> Since the bank->dbck initialization in a one time operation there
> is no need to keep this within gpio_debounce(). Therefore, moving
> clk_get(bank->dbck) to omap_gpio_mod_init(). Since the value of
> bank->dbck would be NULL at the beginning, this check has been
> removed.
>
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>

Applied with Pauld reviewed-by.

Thanks,
Linus Walleij
