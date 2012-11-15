Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767691Ab2KOMds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 07:33:48 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48376 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993283Ab2KOMdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:33:47 -0500
Date: Thu, 15 Nov 2012 12:33:41 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Describe UART platform registering
 issues more accurately
Message-ID: <20121115123341.GA14476@gmail.com>
References: <1352968401-6092-1-git-send-email-lee.jones@linaro.org>
 <201211151223.46989.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201211151223.46989.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Arnd Bergmann wrote:

> On Thursday 15 November 2012, Lee Jones wrote:
> > UARTs no longer require call-back information, since the reset
> > call-back was removed in 43b5f0d69291374f602ad8e1817f329573a59010.
> > The only AUXDATA dependencies remaining for UARTs are DMA settings.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> What is the state of the DMA binding now? We originally wanted to merge
> it for 3.7, but that didn't work out, so I hope we can get it done for
> 3.8.

It's dead. The conversation has been stale for weeks.

Perhaps you'd like to go and poke it? :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
