Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab2E1EUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 00:20:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43716 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2E1EUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 00:20:08 -0400
Date: Mon, 28 May 2012 00:18:01 -0400 (EDT)
Message-Id: <20120528.001801.201603926412931385.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: fix bad merge of sparc Kconfig
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120528134348.c934fef7360aa10683fc3a28@canb.auug.org.au>
References: <20120528134348.c934fef7360aa10683fc3a28@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 27 May 2012 21:18:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 28 May 2012 13:43:48 +1000

> Fixes this sparc32 defconfig build error:
> 
> timekeeping.c:(.text+0x277c4): undefined reference to `arch_gettimeoffset'
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/sparc/Kconfig |    1 -
>  1 file changed, 1 deletion(-)
> 
> Dave, I have been carrying this merge fix in linux-next for a while and
> now it is needed in Linus' tree.

I'll merge this in, thanks Stephen.
