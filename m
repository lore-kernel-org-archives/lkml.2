Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2JODTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 23:19:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59385 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2JODTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 23:19:48 -0400
MIME-Version: 1.0
In-Reply-To: <507A6FA5.1000800@yahoo.es>
References: <507A6FA5.1000800@yahoo.es>
Date: Mon, 15 Oct 2012 08:49:47 +0530
X-Google-Sender-Auth: t9RgsQ2ciUpSxksIRkGLI58i_-0
Message-ID: <CAOh2x=n+tUxuR4B2c=0uh7a1L0Dx8cz2MOCKv-1=qmmRCYYEWg@mail.gmail.com>
Subject: Re: [PATCH REGRESSION FIX] dw_dmac: make driver's endianness configurable
From: viresh kumar <viresh.kumar@linaro.org>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        spear-devel <spear-devel@list.st.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 1:24 PM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> From: Hein Tibosch <hein_tibosch@yahoo.es>
>
> The dw_dmac was originally developed for avr32 to be used with the Synopsys
> DesignWare AHB DMA controller. Starting from 2.6.38, access to the device's i/o
> memory was done with the little-endian readl/writel functions(1)
>
> This broke the driver for the avr32 platform, because it needs big (native)
> endian accessors.
> This patch makes the endianness configurable using 'DW_DMAC_BIG_ENDIAN_IO',
> which will default be true for AVR32
>
> I submitted this patch before(2) but then waited for Andy to finish other
> changes to the same module(3).
>
> (1) https://patchwork.kernel.org/patch/608211
> (2) https://lkml.org/lkml/2012/8/26/148
> (3) https://lkml.org/lkml/2012/9/21/173
>
> Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

Good.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
