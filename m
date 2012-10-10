Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2JJGnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:43:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56311 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2JJGm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:42:58 -0400
MIME-Version: 1.0
In-Reply-To: <1349796183-30648-3-git-send-email-arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
	<1349796183-30648-3-git-send-email-arnd@arndb.de>
Date: Wed, 10 Oct 2012 08:42:57 +0200
Message-ID: <CACRpkdZ2h-V7c9EnQA6+m9sCaBD+tzU-sWrBLRtBTfgbeNWRXQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] ARM: export set_irq_flags
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 5:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> The recently added Emma Mobile GPIO driver calls set_irq_flags
> and irq_set_chip_and_handler for the interrupts it exports and
> it can be built as a module, which currently fails with
>
> ERROR: "set_irq_flags" [drivers/gpio/gpio-em.ko] undefined!
>
> We either need to replace the call to set_irq_flags with something
> else or export that function. This patch does the latter.

Argh! And I cannot think of anything more elegant so
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
