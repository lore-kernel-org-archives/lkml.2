Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab2HJK7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 06:59:35 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52372 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab2HJK7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 06:59:33 -0400
MIME-Version: 1.0
In-Reply-To: <1344437248-20560-7-git-send-email-arnd@arndb.de>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
	<1344437248-20560-7-git-send-email-arnd@arndb.de>
Date: Fri, 10 Aug 2012 12:59:32 +0200
Message-ID: <CACRpkdZnaH3RXHqif7wiA5bor4vOcBndnabG-7QNLnmUc3Oj3Q@mail.gmail.com>
Subject: Re: [PATCH 06/11] gpio: em: do not discard em_gio_irq_domain_cleanup
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 4:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> The newly added gpio-em driver marks its em_gio_irq_domain_cleanup
> function as __devexit, which would lead to that function being
> discarded in case CONFIG_HOTPLUG is disabled. However, the function
> is also called by the error handling logic em_gio_probe, which
> would cause a jump into a NULL pointer if it was removed from the
> kernel or module.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Will you push this through the ARM SoC tree or do you want me
to apply it to my GPIO tree?

Yours,
Linus Walleij
