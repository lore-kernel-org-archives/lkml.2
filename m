Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab2GENHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:07:23 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52515 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524Ab2GENHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:07:20 -0400
MIME-Version: 1.0
In-Reply-To: <1340202832-16850-1-git-send-email-stigge@antcom.de>
References: <1340202832-16850-1-git-send-email-stigge@antcom.de>
Date: Thu, 5 Jul 2012 15:07:19 +0200
Message-ID: <CACRpkdaJy_M32OidaLwC+uFUEx525knwKP+xysLyh0tXx_9N0Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpio-lpc32xx: Add gpio_to_irq mapping
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 4:33 PM, Roland Stigge <stigge@antcom.de> wrote:

> This patch helps mapping with gpio_to_irq for the GPIOs that are irq enabled.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied with Alexandre's Tested-by.

Thanks,
Linus Walleij
