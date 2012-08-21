Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab2HUKoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:44:25 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:53949 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756486Ab2HUKoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:44:21 -0400
MIME-Version: 1.0
In-Reply-To: <1345540555-24359-1-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Tue, 21 Aug 2012 16:13:59 +0530
Message-ID: <CAMQu2gxJqpJG0LbhbJ-YKOEpR=2_ogu2SpdUtvafn2kBXWudyg@mail.gmail.com>
Subject: Re: [RFC/PATCH 00/13] OMAP UART patches
To: Felipe Balbi <balbi@ti.com>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 2:45 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi guys,
>
> here's a series of cleanup patches to the OMAP serial
> driver. A later series could be made re-implementing
> DMA using the DMA Engine API. Note that for RX DMA
> we could be using RX Timeout IRQ as a hint that we better
> use PIO instead ;-)
>
> All patches were tested on my pandaboard, but I'd really
> like to receive Tested-by on other platforms.
>
> After this goes in, I'll probably try to get UART wakeup
> working again and only after that look at DMA.
>
> cheers
>
> Felipe Balbi (13):
>   serial: omap: define and use to_uart_omap_port()
>   serial: omap: always return IRQ_HANDLED
>   serial: omap: define helpers for pdata function pointers
>   serial: omap: don't access the platform_device
>   serial: omap: drop DMA support
>   serial: add OMAP-specific defines
>   serial: omap: simplify IRQ handling
>   serial: omap: refactor receive_chars() into rdi/rlsi handlers
>   serial: omap: move THRE check to transmit_chars()
>   serial: omap: stick to put_autosuspend
>   serial: omap: set dev->drvdata before enabling pm_runtime
>   serial: omap: drop unnecessary check from remove
>   serial: omap: make sure to suspend device before remove
>
Apart from that one question on last patch, rest of the clean-up
is really good. Nice work.

FWIW,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
