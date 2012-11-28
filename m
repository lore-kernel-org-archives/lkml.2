Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab2K1VOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:14:12 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51438 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab2K1VOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:14:10 -0500
Date: Wed, 28 Nov 2012 22:14:07 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Cong Ding <dinggnu@gmail.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers/uio/uio_pdrv_genirq.c: Fix memory leak &
 confusing labels
Message-ID: <20121128211407.GC2590@local>
References: <201211271929.32315.vitas@nppfactor.kiev.ua>
 <CAP9qxA-ZmhZLVujmdM0YLqXony-s8oZggKZxTU6oYmtcuO5erQ@mail.gmail.com>
 <20121128003750.GD2605@local>
 <201211281137.23623.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211281137.23623.vitas@nppfactor.kiev.ua>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 11:37:23AM +0200, Vitalii Demianets wrote:
> On Wednesday 28 November 2012 02:37:50 Hans J. Koch wrote:
> >
> > In other words, the case of uioinfo AND pdev->dev.of_node both being NULL
> > is not handled properly and will have ugly results.
> >
> 
> Moreover, the case of (uioinfo != NULL) && (pdev->dev.of_node != NULL) leads 
> to equally ugly results too (freeing uoinfo when it is statically allocated).

You're right. That wants to be fixed as well.

> 
> I think, we should sort out these problems, but in another patch. It is 
> totally unrelated to the problem solved by the original patch (memory leak 
> caused by not freeing priv in case platform_get_irq() fails).

So far, no patch was applied. I don't mind if all fixes for uio_pdrv_genirq
are in one patch as long as only this one file is altered.

Thanks,
Hans
