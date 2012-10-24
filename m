Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935369Ab2JXRs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:48:27 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59801 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933829Ab2JXRsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:48:25 -0400
MIME-Version: 1.0
In-Reply-To: <1351089926-32161-7-git-send-email-lee.jones@linaro.org>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
	<1351089926-32161-7-git-send-email-lee.jones@linaro.org>
Date: Wed, 24 Oct 2012 19:48:24 +0200
Message-ID: <CACRpkdY88K_qik0=EwJ+mNW80D_D0Hs6t0Y_ydY4x-J_c-i9UQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] ARM: ux500: Convert DT_MACHINE_START to use SMP operations
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The Device Tree machine description for the ux5x0 was moved
> recently and as a consequence missed the addition of SMP
> operations. Without this patch SMP doesn't work and only one
> CPU is present after booting.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
