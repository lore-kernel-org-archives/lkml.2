Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2H3TXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 15:23:03 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:44959 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2H3TXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 15:23:01 -0400
Date: Thu, 30 Aug 2012 21:22:53 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v2] avr32: at32ap700x: set DMA slave properties for MCI
 dw_dmac
Message-ID: <20120830192253.GA10588@samfundet.no>
References: <503F9DC1.9030601@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503F9DC1.9030601@yahoo.es>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Fri 31 Aug 2012 01:07:13 +0800 or thereabout, Hein Tibosch wrote:
> The MCI makes use of the dw_dmac driver when DMA is being used.
> Due to recent changes the driver was broken because:
> - the SMS field in the CTLL register received the wrong value 0
> - a patch in dw_dmac (http://lkml.org/lkml/2012/1/18/52)
> allowed for 64-bit transfers on the memory side, giving an illegal
> value of 3 in the SRC/DST_TR_WIDTH register.
> 
> This patch sets the SMS (Source Master Select) to 1 and limits
> the maximum transfer width to 32 bits.
> 
> Note: this can only be applied after my patch:
> [PATCH v2 2/2] dw_dmac: max_mem_width limits value for
> SRC/DST_TR_WID register
> 
> Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
