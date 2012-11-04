Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2KDSIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 13:08:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48063 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2KDSIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 13:08:10 -0500
MIME-Version: 1.0
In-Reply-To: <1351765331-30617-1-git-send-email-thierry.reding@avionic-design.de>
References: <1351765331-30617-1-git-send-email-thierry.reding@avionic-design.de>
Date: Sun, 4 Nov 2012 19:08:09 +0100
Message-ID: <CACRpkday69Os+Yuv8r-_uS2PBqFeAJo8TBSrCOtG9U4gBamzog@mail.gmail.com>
Subject: Re: [PATCH] gpio: adnp: Depend on OF_GPIO instead of OF
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jamie Lentin <jm@lentin.co.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 11:22 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:

> The driver accesses the of_node field of struct gpio_chip, which is only
> available if OF_GPIO is selected. This solves a build issue on SPARC
> which conflicts with OF_GPIO and therefore does not provide this field.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Thanks! Patch applied.

Yours,
Linus Walleij
