Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2DPI0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:26:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35555 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2DPI0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:26:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120416081532.GA3238@opensource.wolfsonmicro.com>
References: <1334483574-3997-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<CACRpkdZ8yH1ZSG-nQ9dLm0TipHS-jZDuxwqohUC=LGH9V-5q4w@mail.gmail.com>
	<20120416081532.GA3238@opensource.wolfsonmicro.com>
Date: Mon, 16 Apr 2012 10:26:02 +0200
Message-ID: <CACRpkdb8q4bKSBctBV0V5KrbS-r-P_b_+N75UV58ryxK+jz+8A@mail.gmail.com>
Subject: Re: [PATCH] gpiolib/arches: Centralise bolierplate asm/gpio.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, linux@openrisc.net,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        sparclinux@vger.kernel.org, Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 10:15 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Apr 16, 2012 at 09:21:58AM +0200, Linus Walleij wrote:
>
>> This looks good but I think we need to page the alpha, ia64, m68k, microblaze,
>> openrisc etc subarch maintainers on this patch so they have their say.
>
> That's why I CCed linux-arch, to get all the architecture maintainers
> included.  vger would get upset if I CCed everyone individually.

Oh I missed it. I looped in a few maintainers and arch lists anyway.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks!
Linus Walleij
