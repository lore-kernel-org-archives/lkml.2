Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab2I3Vjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 17:39:45 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33967 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2I3Vjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 17:39:43 -0400
MIME-Version: 1.0
In-Reply-To: <1348868177-21205-11-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
	<1348868177-21205-11-git-send-email-arnd@arndb.de>
Date: Sun, 30 Sep 2012 23:39:42 +0200
Message-ID: <CACRpkdYjCQd91O=G9bnZNGtqBjKzwXN1JedLfvPU_Uq4LXboPw@mail.gmail.com>
Subject: Re: [PATCH 10/12] gpio: pcf857x: select IRQ_DOMAIN
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> Patch 6e20a0a4 "gpio: pcf857x: enable gpio_to_irq() support"
> added IRQ domain support to the pcf857x driver, but some configurations
> (e.g. davinci_all_defconfig) don't already enable CONFIG_IRQ_DOMAIN.

Excellent patch Arnd thanks for this!
Applied to my GPIO tree (where the offending patch is queued).

Yours,
Linus Walleij
