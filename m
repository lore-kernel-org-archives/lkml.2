Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161025Ab2JXRhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:37:38 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45762 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab2JXRhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:37:37 -0400
MIME-Version: 1.0
In-Reply-To: <1351089926-32161-2-git-send-email-lee.jones@linaro.org>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
	<1351089926-32161-2-git-send-email-lee.jones@linaro.org>
Date: Wed, 24 Oct 2012 19:37:35 +0200
Message-ID: <CACRpkdZbTeaa4dQJ1Nxs38_gM+yUS=FxA-Fgie-ZbtKne51C3A@mail.gmail.com>
Subject: Re: [PATCH 1/6] mfd: ab8500-core: Remove unused ab8500-gpio IRQ ranges
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The IRQ ranges provided in ab8500-core to be passed on to the
> ab8500-gpio driver are not only redundant, but they are also
> causing a warning in the boot log. These IRQ ranges, like any
> other MFD related IRQ resource are passed though MFD core for
> automatic conversion to virtual IRQs; however, MFD core does
> not support IRQ mapping of IRQ ranges. Let's just remove them.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Hey! That riddes the pesky boot warning.
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Sam, please pick this into the MFD tree for the -rc series!

Yours,
Linus Walleij
