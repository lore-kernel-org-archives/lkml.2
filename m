Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964941Ab2HHNY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:24:27 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49202 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496Ab2HHNYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:24:24 -0400
MIME-Version: 1.0
In-Reply-To: <1344430493-5304-6-git-send-email-arnd@arndb.de>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de>
	<1344430493-5304-6-git-send-email-arnd@arndb.de>
Date: Wed, 8 Aug 2012 15:24:23 +0200
Message-ID: <CACRpkdYbHTtOg6inbemD2SG+XT9ZYN3pcFQjEPv7mbyecagawg@mail.gmail.com>
Subject: Re: [PATCH 5/6] ARM: integrator: include <linux/export.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 2:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> Without this patch, building integrator_defconfig results in:
>
> arch/arm/mach-integrator/core.c:150:1: warning: data definition has no type or storage class [enabled by default]
> arch/arm/mach-integrator/core.c:150:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
> arch/arm/mach-integrator/core.c:150:1: warning: parameter names (without types) in function declaration [enabled by default]
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>

Missing a ">" at the end of the subject line, but whatever.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
