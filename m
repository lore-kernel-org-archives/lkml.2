Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab2HaXtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:49:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2HaXtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:49:45 -0400
Date: Fri, 31 Aug 2012 16:49:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: viresh kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, egtvedt@samfundet.no,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/2] dw_dmac: max_mem_width limits value for
 SRC/DST_TR_WID register
Message-Id: <20120831164943.f4b4531c.akpm@linux-foundation.org>
In-Reply-To: <503A89E0.40602@yahoo.es>
References: <503A89E0.40602@yahoo.es>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2012 04:41:04 +0800
Hein Tibosch <hein_tibosch@yahoo.es> wrote:

> The dw_dmac driver was earlier adapted to do 64-bit transfers
> on the memory side (https://lkml.org/lkml/2012/1/18/52)
> This works on ARM platforms but for AVR32 (AP700x) the maximum
> allowed transfer size is 32-bits.
> This patch allows the arch to set a new slave property
> max_mem_width to limit the size.
> Allowable values for dw_dma_slave::max_mem_width are:
> 

This patch fails to apply to mainline and to linux-next and I can't
work out how to make it to apply to either.  And "avr32-linux:
at32ap700x: set DMA slave properties for MCI dw_dmac" is said to depend
on this patch.

All confused, giving up.
