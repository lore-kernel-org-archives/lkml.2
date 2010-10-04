Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab0JDOul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 10:50:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47069 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0JDOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 10:50:40 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/5] arm/davinci: remove duplicated include
Organization: Deep Root Systems, LLC
References: <20101004122436.7092868f@absol.kitzblitz>
	<20101004123947.1e89128f@absol.kitzblitz>
Date: Mon, 04 Oct 2010 07:50:35 -0700
In-Reply-To: <20101004123947.1e89128f@absol.kitzblitz> (Nicolas Kaiser's
	message of "Mon, 4 Oct 2010 12:39:47 +0200")
Message-ID: <87fwwm3tc4.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Kaiser <nikai@nikai.net> writes:

> Remove duplicated include.
>
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Applied, thanks.  Queuing for 2.6.37.

Kevin

> ---
>  arch/arm/mach-davinci/board-da850-evm.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index fdc2cc5..851cc45 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -26,7 +26,6 @@
>  #include <linux/mtd/physmap.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/regulator/tps6507x.h>
> -#include <linux/mfd/tps6507x.h>
>  #include <linux/input/tps6507x-ts.h>
>  
>  #include <asm/mach-types.h>
