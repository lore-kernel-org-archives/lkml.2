Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1GaHAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 03:00:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:53877 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1GaG77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 02:59:59 -0400
Date: Sun, 31 Jul 2011 02:59:54 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20110731065954.GF31842@windriver.com>
References: <20110729170933.b7bfc24dcf48201928bd5890@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110729170933.b7bfc24dcf48201928bd5890@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-next: build failure after merge of the moduleh tree] On 29/07/2011 (Fri 17:09) Stephen Rothwell wrote:

> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (sparc defconfig)
> failed like this:

[...]

> Again, I have left these unfixed in linux-next today.

Thanks, I've got these sparc32 items all fixed up; I wasn't thinking
that my allyesconfig would have excluded sparc32.  I've retested with
the two defconfigs, all[yes,no,mod]config to make sure I didn't miss
any other module.h cleanup fallout for sparc.

Paul.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/


