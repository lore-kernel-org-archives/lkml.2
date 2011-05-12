Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab1ELVFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:05:31 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59451 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758661Ab1ELVF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:05:29 -0400
Date: Thu, 12 May 2011 17:02:54 -0400 (EDT)
Message-Id: <20110512.170254.1553444447781324461.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: shemminger@vyatta.com, ysato@users.sourceforge.jp, linux@arm.linux.org.uk,
        fthain@telegraphics.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix 8390 regressions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305227500-15595-1-git-send-email-geert@linux-m68k.org>
References: <1305227500-15595-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 14:02:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 12 May 2011 19:11:37 +0000

> These patches fix regressions in 3 8390-based network drivers:
>  [1/3] zorro8390: Fix regression caused during net_device_ops conversion
>  [2/3] hydra: Fix regression caused during net_device_ops conversion
>  [3/3] ne-h8300: Fix regression caused during net_device_ops conversion
> 
> The first one, for zorro8390, has been tested.
> The second one, for hydra, has been compile-tested only.
> 
> Based on commits 8cfd9e923be54ef66ce174a93f4592b444b96407 ("[ARM] RiscPC: Fix
> etherh oops") and 217cbfa856dc1cbc2890781626c4032d9e3ec59f ("mac8390: fix
> regression caused during net_device_ops conversion"), and the patch for
> zorro8390, we have good reasons to believe hydra and ne-h8300 are affected
> as well, as they all include lib8390.c.
> Hence patches for those are also included, although I could not test them.

All applied, thanks Geert, and I made the "From: " removals you requested.
