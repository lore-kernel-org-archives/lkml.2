Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab2HaXoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:44:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2HaXoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:44:37 -0400
Date: Fri, 31 Aug 2012 16:44:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: egtvedt@samfundet.no,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] avr32-linux: at32ap700x: set DMA slave properties for
 MCI dw_dmac
Message-Id: <20120831164435.a1b72191.akpm@linux-foundation.org>
In-Reply-To: <503A8D97.4070403@yahoo.es>
References: <503A8D97.4070403@yahoo.es>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2012 04:56:55 +0800
Hein Tibosch <hein_tibosch@yahoo.es> wrote:

> The MCI makes use of the dw_dmac driver when DMA is being used.
> Due to recent changes the driver was broken because:
> - the SMS field in the CTLL register received the wrong value 0
> - a patch in dw_dmac allowed for 64-bit transfers on the
> memory side, giving an illegal value of 3 in the SRC/DST_TR_WIDTH
> register.

Please try to avoid vague descriptions such as "recent changes" and "a
patch".  We like to see specifics: commit IDs and titles.

This way we can make more informed decisions about patch scheduling. 
We can ensure that the authors of the earlier commits get to review
these changes.  Maintainers of other trees can determine whether or not
their tree needs the particular fix.
