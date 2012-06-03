Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab2FCTtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 15:49:50 -0400
Received: from antcom.de ([188.40.178.216]:52045 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab2FCTtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 15:49:45 -0400
Message-ID: <4FCBBFD4.9090401@antcom.de>
Date: Sun, 03 Jun 2012 21:49:40 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        dedekind1@gmail.com
Subject: Re: [PATCH v4] MTD: LPC32xx SLC NAND driver
References: <1338748689-29645-1-git-send-email-stigge@antcom.de> <20120603190932.GB23368@n2100.arm.linux.org.uk>
In-Reply-To: <20120603190932.GB23368@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Thanks for the suggestions!

On 03/06/12 21:09, Russell King - ARM Linux wrote:
>> +	dma_async_issue_pending(host->dma_chan);
>> +
>> +	wait_for_completion_timeout(&host->comp, msecs_to_jiffies(1000));
> 
> What about unmapping the buffer upon completion?

OK - by not specifying DMA_COMPL_SKIP_*_UNMAP in flags, I was thinking
that this happens somehow magically. ;-) But maybe I was just confused.

Thanks,

Roland
