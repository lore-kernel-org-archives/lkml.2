Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2LASLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 13:11:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36730 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab2LASLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 13:11:13 -0500
MIME-Version: 1.0
In-Reply-To: <1354221910-22493-2-git-send-email-mcgrof@do-not-panic.com>
References: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
	<1354221910-22493-2-git-send-email-mcgrof@do-not-panic.com>
Date: Sat, 1 Dec 2012 19:11:11 +0100
Message-ID: <CACRpkdYD=h9YL=GrwuQvBzjpek08MvumCnhX3SiXow63nLLP1Q@mail.gmail.com>
Subject: Re: [PATCH 1/6] ux500: convert struct spinlock to spinlock_t
From: Linus Walleij <linus.walleij@linaro.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Arun MURTHY <arun.murthy@stericsson.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        backports@vger.kernel.org, alexander.stein@systec-electronic.com,
        brudley@broadcom.com, rvossen@broadcom.com, arend@broadcom.com,
        frankyl@broadcom.com, kanyan@broadcom.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 9:45 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:

> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>
> spinlock_t should always be used.
>
> I was unable to build test with allmodconfig:
>
> mcgrof@frijol ~/linux-next (git::(no branch))$ make C=1 M=drivers/crypto/ux500/
>
>   WARNING: Symbol version dump /home/mcgrof/linux-next/Module.symvers
>            is missing; modules will have no dependencies and modversions.
>
>   LD      drivers/crypto/ux500/built-in.o
>   Building modules, stage 2.
>   MODPOST 0 modules
>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

Looks correct to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
