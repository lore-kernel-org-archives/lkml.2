Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab2FTIPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:15:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54787 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2FTIPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:15:48 -0400
MIME-Version: 1.0
In-Reply-To: <1340050738-22988-1-git-send-email-stigge@antcom.de>
References: <1340050738-22988-1-git-send-email-stigge@antcom.de>
Date: Wed, 20 Jun 2012 10:15:47 +0200
Message-ID: <CACRpkdbCTLrOj5LOsDbVBsOO1W-etCXp_sV+OqG=Tc7UjQQJ9w@mail.gmail.com>
Subject: Re: [PATCH RESEND] gpio: LPC32xx: Driver cleanup
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 10:18 PM, Roland Stigge <stigge@antcom.de> wrote:

> Since LPC32xx is now switched over to devicetree based GPIO, the unused
> lpc32xx_gpio_init() can be removed.
>
> Further, the driver title changed since it referred to the wrong file.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
