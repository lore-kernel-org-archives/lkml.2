Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab2LXLHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 06:07:25 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:37679 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2LXLHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 06:07:23 -0500
Message-ID: <50D8376B.30202@mvista.com>
Date: Mon, 24 Dec 2012 15:07:23 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Shane McDonald <mcdonald.shane@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        ralf@linux-mips.org
Subject: Re: [PATCH] MIPS: MSP71xx: Move include files
References: <E1Tn02j-0003nm-Hh@localhost>
In-Reply-To: <E1Tn02j-0003nm-Hh@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-12-2012 8:53, Shane McDonald wrote:

> Now that Yosemite's gone we can move the MSP71xx include files
> one level up.

> Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
> ---
>   .../asm/mach-pmcs-msp71xx/cpu-feature-overrides.h  |   22 +
>   arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h     |   46 ++
>   .../include/asm/mach-pmcs-msp71xx/msp_cic_int.h    |  151 +++++
>   .../asm/mach-pmcs-msp71xx/msp_gpio_macros.h        |  343 ++++++++++
>   arch/mips/include/asm/mach-pmcs-msp71xx/msp_int.h  |   43 ++
>   arch/mips/include/asm/mach-pmcs-msp71xx/msp_pci.h  |  205 ++++++
>   arch/mips/include/asm/mach-pmcs-msp71xx/msp_prom.h |  171 +++++
>   .../include/asm/mach-pmcs-msp71xx/msp_regops.h     |  236 +++++++
>   arch/mips/include/asm/mach-pmcs-msp71xx/msp_regs.h |  664 ++++++++++++++++++++
>   .../include/asm/mach-pmcs-msp71xx/msp_slp_int.h    |  141 +++++
>   arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h  |  144 +++++
>   arch/mips/include/asm/mach-pmcs-msp71xx/war.h      |   29 +
>   .../asm/pmc-sierra/msp71xx/cpu-feature-overrides.h |   22 -
>   arch/mips/include/asm/pmc-sierra/msp71xx/gpio.h    |   46 --
>   .../include/asm/pmc-sierra/msp71xx/msp_cic_int.h   |  151 -----
>   .../asm/pmc-sierra/msp71xx/msp_gpio_macros.h       |  343 ----------
>   arch/mips/include/asm/pmc-sierra/msp71xx/msp_int.h |   43 --
>   arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h |  205 ------
>   .../mips/include/asm/pmc-sierra/msp71xx/msp_prom.h |  171 -----
>   .../include/asm/pmc-sierra/msp71xx/msp_regops.h    |  236 -------
>   .../mips/include/asm/pmc-sierra/msp71xx/msp_regs.h |  664 --------------------
>   .../include/asm/pmc-sierra/msp71xx/msp_slp_int.h   |  141 -----
>   arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h |  144 -----
>   arch/mips/include/asm/pmc-sierra/msp71xx/war.h     |   29 -
>   arch/mips/pmcs-msp71xx/Platform                    |    2 +-
>   25 files changed, 2196 insertions(+), 2196 deletions(-)
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/cpu-feature-overrides.h
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_cic_int.h
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_gpio_macros.h
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_int.h
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_pci.h
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_prom.h
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_regops.h
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_regs.h
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_slp_int.h
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h
>   create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/war.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/gpio.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_cic_int.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_int.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_prom.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_regops.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_slp_int.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h
>   delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/war.h

    You should have generated the patch with -M option (IIRC) to detect the 
file moves.

WBR, Sergei

