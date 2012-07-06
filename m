Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2GFHSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 03:18:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57288 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab2GFHSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 03:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <1341493572-29735-8-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<1341493572-29735-8-git-send-email-lee.jones@linaro.org>
Date: Fri, 6 Jul 2012 09:18:10 +0200
Message-ID: <CACRpkdZmb+4ypnDb3Xw-N5svSBfQ-6oWNy3=iXizZwSio+jHAw@mail.gmail.com>
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Kalle Komierowski <karl.komierowski@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Arun MURTHY <arun.murthy@stericsson.com>,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 3:06 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Before we can use any domain allocated IRQ, we need to first create a
> map between the Hardware IRQ (hwirq) and the Linux Virtual IRQ (virq).
> We do this with a helper function provided by the AB8500 IRQ domain
> controller called ab8500_irq_get_virq(). We need to do this for both
> IRQs which the Power-On-Key driver uses; one for button press, the other
> for button depress.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Lee I think the in-kernel charging drivers in drivers/power/ab8500_* are
also using the IRQs, have you checked that these also do the right
thing? (I realize they may be hard to test, but atleast make an effort).

Please coordinate with Rajanikanth who is working on DT:ing
these drivers.

Yours,
Linus Walleij
