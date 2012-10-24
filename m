Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223Ab2JXRqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:46:40 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:36507 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030204Ab2JXRqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:46:38 -0400
MIME-Version: 1.0
In-Reply-To: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
Date: Wed, 24 Oct 2012 19:46:36 +0200
Message-ID: <CACRpkdawesrrAv3FAJLrWm-Rvvwkf17gbesiXN-LEFRWfBaB6A@mail.gmail.com>
Subject: Re: [PATCH 0/6] ux500 fixes bound for the -rcs
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 4:45 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch-set contains a bunch of fixes which are bound for the
> v3.6 Release Candidates. Each of them provides a fix for something
> which went wrong during the merge window. Without them we either
> can't build the kernel, have no GPIOs, only have one running CPU
> core, see unnecessary WARN()s, or individual devices fail at to be
> functional.
>
>  arch/arm/boot/dts/dbx5x0.dtsi     |   17 ++++++-
>  arch/arm/mach-ux500/cpu-db8500.c  |    1 +
>  arch/arm/mach-ux500/cpu.c         |    1 +

I provide my Acked-by for patches: 3,4,5,6 of this series.

I tried to apply them to my ux500 fixes branch but it appears
there are dependencies in the .dtsi file and it does not apply
so I guess it's better if you send these to the ARM SoC tree
yourself.

Patches 1,2 need to go through respective subtrees and
I need review comments on the pinctrl patch.

Yours,
Linus Walleij
