Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0IQU7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:59:52 -0400
Received: from www.tglx.de ([62.245.132.106]:46276 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab0IQU7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:59:51 -0400
Date: Fri, 17 Sep 2010 22:59:46 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Uio enhancements
Message-ID: <20100917205946.GF2522@local>
References: <m1y6b48973.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6b48973.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 11:35:28AM -0700, Eric W. Biederman wrote:
> 
> Looking through my patch queue I stumbled upon some uio changes
> that I have been using for a while and I forgot to push upstream.
> 
> Ultimately I am working on making uio devices hoptlugable, but I figure
> I should get these enhancements in first.
> 
> Eric W. Biederman (5):
>       uio: Fix lack of locking in init_uio_class
>       uio: Don't clear driver data
>       uio: Cleanup irq handling.
>       uio: Support 2^MINOR_BITS minors
>       uio: Statically allocate uio_class and use class .dev_attrs.

Looks good to me, thanks a lot for your contribution!

Thanks,
Hans

> ---
>  drivers/uio/uio.c          |  165 +++++++++++++++++++-------------------------
>  include/linux/uio_driver.h |    2 +-
>  2 files changed, 71 insertions(+), 96 deletions(-)
