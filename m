Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2JJGk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:40:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45026 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2JJGks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <1349796861-31164-4-git-send-email-arnd@arndb.de>
References: <1349796861-31164-1-git-send-email-arnd@arndb.de>
	<1349796861-31164-4-git-send-email-arnd@arndb.de>
Date: Wed, 10 Oct 2012 08:40:46 +0200
Message-ID: <CACRpkdb7rTBwhKDJxuP00h29zx8HAnB4ptHHHs9ht4yBZovfRw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: integrator: use __iomem pointers for MMIO, part 2
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 5:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> Due to some interesting merges in the integrator code, not
> all users of mmio pointers were converted before, this
> fixes all warnings that got introduced as a consequence.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>

Yeah I told you it was gonna collide ;-)

Thanks a lot for fixing it up and following through
on this!

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
