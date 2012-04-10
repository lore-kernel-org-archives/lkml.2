Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516Ab2DJVyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 17:54:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28853 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab2DJVx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 17:53:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6676"; a="180481814"
Date: Tue, 10 Apr 2012 16:53:57 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Linas Vepstas <linasvepstas@gmail.com>, trivial@kernel.org
Subject: Re: [PATCH][resend] hexagon: Remove unneeded include of version.h
Message-ID: <20120410215356.GA2513@codeaurora.org>
References: <alpine.LNX.2.00.1204102333460.31626@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204102333460.31626@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 11:37:23PM +0200, Jesper Juhl wrote:
> "make versioncheck" points out that arch/hexagon/include/asm/spinlock_types.h
> does not need to include version.h .
> A quick look at the file seems to confirm its findings, so here's a patch that
> removes the include.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Acked-by: Linas Vepstas <linasvepstas@gmail.com>
> ---
>  arch/hexagon/include/asm/spinlock_types.h |    2 --
>  1 file changed, 2 deletions(-)
> 

I've applied this patch to my tree (it's already spent some time in
linux-next as well) and it will go out with my next pull request.


Thanks,
Richard Kuo

