Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767574Ab2KOLeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:34:04 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59344 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993197Ab2KOLeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:34:02 -0500
MIME-Version: 1.0
In-Reply-To: <1352882265.12579.2.camel@phoenix>
References: <1352882265.12579.2.camel@phoenix>
Date: Thu, 15 Nov 2012 12:34:00 +0100
Message-ID: <CACRpkdaXVvGh=pdJsuh-fBHvvjZM8QzxLpFa2yVwwEDRXikH4Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: plgpio: Call clk_disable_unprepare only if
 clk_prepare_enable is called
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 9:37 AM, Axel Lin <axel.lin@ingics.com> wrote:

> This driver allows clk_get() failure, and still work without it.
> This patch adds !IS_ERR(plgpio->clk) checking in plgpio_request() error path
> so we only call clk_disable_unprepare() if clk_prepare_enable() is called.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Viresh's ACK, thanks!

Yours,
Linus Walleij
