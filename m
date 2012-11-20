Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2KTMmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:42:35 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60625 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2KTMme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:42:34 -0500
MIME-Version: 1.0
In-Reply-To: <9bdc33093c6a5c22b180ef45b486edb575f87da3.1353349191.git.josh.cartwright@ni.com>
References: <cover.1353349191.git.josh.cartwright@ni.com>
	<9bdc33093c6a5c22b180ef45b486edb575f87da3.1353349191.git.josh.cartwright@ni.com>
Date: Tue, 20 Nov 2012 13:42:33 +0100
X-Google-Sender-Auth: jb6pLzuyv3QFAm4Zl28tvlLD-CY
Message-ID: <CAHTX3d+UEdgHVALa9a7pqKPpKbZdoPOWzMPcTXpJ0TY7YofzRw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: zynq: add support for ARCH_MULTIPLATFORM
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/19 Josh Cartwright <josh.cartwright@ni.com>:
> The majority of changes are necessary to remove dependencies on header
> files within arch/arm/mach-zynq/include/mach:
>
>   uncompress.h
>     - Deleted. It is unused for ARCH_MULTIPLATFORM builds.
>
>   uart.h:
>     - Move uart definitions out of uart.h into debug/zynq.S, which is
>       now the only user
>
>   zynq_soc.h:
>     - Move SCU address definitions into common.c.
>     - Other #defines, such as PERIPHERAL_CLOCK_RATE, TTC0_BASE, etc, are
>       unused and can be dropped
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> ---
>  arch/arm/Kconfig                             | 14 ++------
>  arch/arm/include/debug/zynq.S                | 20 +++++++++--
>  arch/arm/mach-zynq/Kconfig                   | 13 +++++++
>  arch/arm/mach-zynq/common.c                  |  8 ++---
>  arch/arm/mach-zynq/include/mach/uart.h       | 25 --------------
>  arch/arm/mach-zynq/include/mach/uncompress.h | 51 ----------------------------
>  arch/arm/mach-zynq/include/mach/zynq_soc.h   | 49 --------------------------
>  7 files changed, 37 insertions(+), 143 deletions(-)
>  create mode 100644 arch/arm/mach-zynq/Kconfig
>  delete mode 100644 arch/arm/mach-zynq/include/mach/uart.h
>  delete mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
>  delete mode 100644 arch/arm/mach-zynq/include/mach/zynq_soc.h

Tested-by: Michal Simek <michal.simek@xilinx.com>

Applied to xilinx arm-next branch.

Thanks,
Michal
