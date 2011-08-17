Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1HQUjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:39:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1HQUjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch 02/36] Hexagon: Core arch-specific header files
Date: Wed, 17 Aug 2011 21:19:04 +0200
Message-ID: <1351105.60z76SzR1l@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163520.053182080@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163520.053182080@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:M3Ub0fVJHByBp9lRYCCZDLPXSoVns+2GFDqIfCUMXZC
 rjDMjsubH7R23wH/h/BlZefTOG44ZnETloGJtb0vQ1Y5vzsmnc
 TtjoJ+3qz4XQiSkmeI2UNhntjRlMwSs7VISmznAE5OzLT67DyD
 5LG5/X9e1m3BePTkAzwgF+BLMGNTgJPF13VUo4l1eg4ZwudRSP
 SEAvRYe5d8H6e9tGTBNTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:34:59 Richard Kuo wrote:

> +#ifndef _ASM_TIMEX_H
> +#define _ASM_TIMEX_H
> +
> +#include <asm-generic/timex.h>
> +#include <asm/timer-regs.h>
> +
> +/*  Using TCX0 as our clock.  */
> +#define CLOCK_TICK_RATE		TCX0_CLK_RATE
> +
> +#endif

CLOCK_TICK_RATE will no longer be there in Linux-3.2, after a patch from
Deepak Saxena. If you rely on it anywhere, change that to use your
TCX0_CLK_RATE directly.

	Arnd
