Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab2KQUVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 15:21:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41300 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2KQUVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 15:21:02 -0500
MIME-Version: 1.0
In-Reply-To: <1352987980-5112-1-git-send-email-stigge@antcom.de>
References: <1352987980-5112-1-git-send-email-stigge@antcom.de>
Date: Sat, 17 Nov 2012 21:21:01 +0100
Message-ID: <CACRpkda2FNAOrNBeyedLXvPWfOdEttQxiQwnu4iFHqmCLpk9+g@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpio-max710x: Support device tree probing
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, jbe@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 2:59 PM, Roland Stigge <stigge@antcom.de> wrote:

> For probing via device tree, we need to support the case without platform_data.
> In this case, chip.base is set to -1 for automatic numbering.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Patch applied with Wolfram's ACK.
Thanks!

Yours,
Linus Walleij
