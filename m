Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab2H3T5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 15:57:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2H3T5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 15:57:17 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Hein Tibosch <hein_tibosch@yahoo.es>
Subject: Re: [PATCH v2 1/2] dw_dmac: make driver endianness configurable
Date: Thu, 30 Aug 2012 19:57:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: viresh kumar <viresh.kumar@linaro.org>,
        "spear-devel" <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        Andrew Morton <akpm@linux-foundation.org>
References: <503FA259.3090602@yahoo.es>
In-Reply-To: <503FA259.3090602@yahoo.es>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208301957.09493.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:cmgYNOfwrlp+cKslXCcVP5uSs9NHVQ6S7zPnY+BhkYT
 JctkvPY+TD/oIrk+rckzimqYryudESFJZ+/kiWdzifkPILxSMk
 2q0I1LyScudxI/EbOj8PdPI+5a5evzvjknstYCa4dBWvRuz/81
 I0Qhpu1JCAgJquKAunNNrTsxWA+p9jsBvemhDqRckJtwGc52pe
 xdrlLc6VNEePjve3Yf8h758oo9r7yaid35/o/8D6WpmTOSv+HF
 zRCvHUn6zrx3eANOsdiCMLuMKbhGBNI5f8uvNd+GIaXoiSoT27
 7WrUa89jrKxH0MStzAGzbGQn6gjv5dRfujqoce6dxG/1qm3eYs
 6SlgZfSuBLyFCaNfGYZwoEe5s85lTEeUtAh3NSBhL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 August 2012, Hein Tibosch wrote:
> The dw_dmac was originally developed for avr32 to be used with the
> Synopsys DesignWare AHB DMA controller. After 2.6.38, device access was done
> with the little-endian readl/writel functions. This didn't work on the
> avr32 platform, because it needs native-endian (i.e. big-endian) accessors.
> This patch makes the endianness configurable using 'DW_DMAC_BIG_ENDIAN_IO',
> which will default be true for AVR32
> 
> 
> Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

Acked-by: Arnd Bergmann <arnd.bergmann@linaro.org>
