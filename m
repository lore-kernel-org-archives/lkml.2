Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2JNTJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:09:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2JNTJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:09:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Subject: Re: [PATCH REGRESSION FIX] dw_dmac: make driver's endianness configurable
Date: Sun, 14 Oct 2012 19:09:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        "spear-devel" <spear-devel@list.st.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
References: <507A6FA5.1000800@yahoo.es>
In-Reply-To: <507A6FA5.1000800@yahoo.es>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210141909.34098.arnd@arndb.de>
X-Provags-ID: V02:K0:18FcekZipBfhWdQAOwuj6mIIqi3nRrYKb/Bvie28AvC
 eYpTHbjWCGCJr226m6/e2P4+IpnlqCsXSvHK2wsx13abQ1uqqS
 iHAm+mHNYN+G54Yf/GLTbpwa6NS2Zq40kGVggNXIST0rL+lqyu
 isnYQiqW/aiU37f7SsxKiVQP5K2QZTvJ4WN0QwEHRI7Zldm6M0
 htUM42cO+57USowdLsdZaatgE3ZouWI3vokSmR6q8YG9kHxKDG
 Ql5GjOos/NhB38jY0ri+x1B24qK7WTdTWasYxq3ahXE3wgT0z5
 zUwLRqF3LdSdqn63b3bEfUkfvJfNasPBgQyeAaZk4NJH4YgpTv
 FcUCeGauzUNb0UKtAesk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2012, Hein Tibosch wrote:
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

Acked-by: Arnd Bergmann <arnd@arndb.de>
