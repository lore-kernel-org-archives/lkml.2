Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1BJN52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:57:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44402 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab1BJN51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:57:27 -0500
Message-ID: <4D53EEC1.5020101@monstr.eu>
Date: Thu, 10 Feb 2011 14:57:21 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH OF 07/14] of: move of_irq_map_pci() into generic code
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-8-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1295843342-1122-8-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior wrote:
> From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> There is a tiny difference between PPC32 and PPC64. Microblaze uses the
> PPC32 variant.
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

> ---
>  arch/microblaze/include/asm/pci-bridge.h |   12 ++++
>  arch/microblaze/include/asm/prom.h       |   15 -----
>  arch/microblaze/kernel/prom_parse.c      |   77 ---------------------------
>  arch/microblaze/pci/pci-common.c         |    1 +

Please always CC me for Microblaze changes. I want to at least compile it.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
