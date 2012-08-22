Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab2HVJgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:36:55 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38821 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab2HVJgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <1345460017-404-1-git-send-email-lee.jones@linaro.org>
References: <1345460017-404-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 22 Aug 2012 11:36:51 +0200
Message-ID: <CACRpkdZu5o9mzY7Foktu0cL5pp2o+CRfvkmGzQj+TQKAL8QfYA@mail.gmail.com>
Subject: Re: [PATCH] mfd: ab8500: Make ab8500_irq_get_virq() static
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 12:53 PM, Lee Jones <lee.jones@linaro.org> wrote:

> MFD core now takes care of  HWIRQ <-> VIRQ mapping, so the helper
> ab8500_irq_get_virq() is no longer used by ab8500 subordinate devices
> to obtain a Linux wide Virtual IRQ. The AB8500 IRQ controller still
> uses it internally though, so we'll just hide it from the rest of the
> world by making it static instead.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Luv this patch, well done!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
