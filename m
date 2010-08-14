Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934752Ab0HNNns (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 09:43:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:40026 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215Ab0HNNn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 09:43:28 -0400
Date: Sat, 14 Aug 2010 06:43:43 -0700
From: Greg KH <gregkh@suse.de>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Call traces w/ 2.6.35.2 (not w/ 2.6.35.1 plus 2.6.35.2-rc1)
Message-ID: <20100814134343.GD17430@suse.de>
References: <AANLkTi=YL_VKKDU8ok=OYotPhyQcGsVB2O-PU29+70YT@mail.gmail.com> <AANLkTikP3FHZ0f7umRRzXcT1ytfa9XfE41UHmQ98kO2h@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikP3FHZ0f7umRRzXcT1ytfa9XfE41UHmQ98kO2h@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 08:36:30AM +0200, Sedat Dilek wrote:
> Hope this helps to give an overview what has changed:
> 
> $ grep "diff --git" patch-2.6.35.2 | sort > list.patch-2.6.35.2
> $ grep "diff --git" new.patch | sort > list.patch-2.6.35.1+patch-2.6.35.2-rc1
> 
> 
> $ diff -Naur list.patch-2.6.35.2
> list.patch-2.6.35.1+patch-2.6.35.2-rc1 | grep ^+diff
> +diff --git a/arch/arm/plat-mxc/include/mach/gpio.h
> b/arch/arm/plat-mxc/include/mach/gpio.h
> +diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
> +diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
> +diff --git a/fs/block_dev.c b/fs/block_dev.c
> +diff --git a/include/linux/notifier.h b/include/linux/notifier.h
> +diff --git a/Makefile b/Makefile
> 
> $ diff -Naur list.patch-2.6.35.2
> list.patch-2.6.35.1+patch-2.6.35.2-rc1 | grep ^-diff
> -diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> -diff --git a/mm/memory.c b/mm/memory.c
> 
> $ ls -l list.patch-2.6.35.*
> -rw-r--r-- 1 sd sd 9004 14. Aug 08:32 list.patch-2.6.35.1+patch-2.6.35.2-rc1
> -rw-r--r-- 1 sd sd 8724 14. Aug 08:32 list.patch-2.6.35.2

I still fail to understand what you are trying to show here at all.

confused,

greg k-h
