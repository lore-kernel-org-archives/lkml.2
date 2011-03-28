Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1C1NnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:43:14 -0400
Received: from void.printf.net ([89.145.121.20]:47233 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab1C1NnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:43:12 -0400
From: Chris Ball <cjb@laptop.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: SDHI should depend on SUPERH || ARCH_SHMOBILE
References: <20110328131018.96742ebb.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.1103280913170.6625@axis700.grange>
Date: Mon, 28 Mar 2011 09:39:04 -0400
In-Reply-To: <Pine.LNX.4.64.1103280913170.6625@axis700.grange> (Guennadi
	Liakhovetski's message of "Mon, 28 Mar 2011 09:16:33 +0200 (CEST)")
Message-ID: <m3lizzicuf.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 28 2011, Guennadi Liakhovetski wrote:
> Fix build breakage on platforms, not providing readsw and writesw
> functions, e.g., on x86(_64).
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> Subject: Re: linux-next: build failure after merge of the mmc tree
>
> On Mon, 28 Mar 2011, Stephen Rothwell wrote:
>
>> Hi Chris,
>> 
>> After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
>> failed like this:
>> 
>> drivers/mmc/host/tmio_mmc_pio.c: In function 'sd_ctrl_read16_rep':
>> drivers/mmc/host/tmio_mmc_pio.c:56: error: implicit declaration of function 'readsw'
>> drivers/mmc/host/tmio_mmc_pio.c: In function 'sd_ctrl_write16_rep':
>> drivers/mmc/host/tmio_mmc_pio.c:73: error: implicit declaration of function 'writesw'
>> 
>> Presumably caused by commit b6147490e6aa ("mmc: tmio: split core
>> functionality, DMA and MFD glue").
>> 
>> I have used the mmc tree from next-20110325 for tdoay.
>
> Stephen, please verify, that this fixes your problem.

I've verified the fix and pushed it to mmc-next, so this should be fixed
tomorrow.  Thanks!

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
