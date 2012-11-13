Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2KMWRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:17:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50526 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2KMWRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:17:40 -0500
Date: Tue, 13 Nov 2012 17:17:36 -0500 (EST)
Message-Id: <20121113.171736.561094209116852795.davem@davemloft.net>
To: joe@perches.com
Cc: rob@landley.net, harryxiyou@gmail.com, jdike@addtoit.com, richard@nod.at,
        linux@arm.linux.org.uk, ralf@linux-mips.org, benh@kernel.crashing.org,
        paulus@samba.org, chris@zankel.net, jcmvbkbc@gmail.com,
        isdn@linux-pingi.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiyoulinuxkernelgroup@googlegroups.com,
        linux-kernel@zh-kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org
Subject: Re: [PATCH V2] wanrouter: Remove it and the drivers that depend on
 it
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352837845.12850.3.camel@joe-AO722>
References: <67fe0c5701a8c7cfe06b178cf04b1c5c06592714.1352548454.git.joe@perches.com>
	<20121113.144406.1610017702502358739.davem@davemloft.net>
	<1352837845.12850.3.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 13 Nov 2012 12:17:25 -0800

> That seems an odd workflow as it leaves dangling CONFIG_<foo>
> options set, but I guess it doesn't hurt so here it is.

As you said it's harmless, and more importantly it avoids
unnecessary conflicts.

> I just removed the modified arch/.../<foo>defconfig files.

Something is not right here:

[davem@drr net-next]$ git am --signoff V2-wanrouter-Remove-it-and-the-drivers-that-depend-on-it.patch 
Applying: wanrouter: Remove it and the drivers that depend on it
error: removal patch leaves file contents
error: net/wanrouter/Kconfig: patch does not apply
error: removal patch leaves file contents
error: net/wanrouter/Makefile: patch does not apply
error: removal patch leaves file contents
error: net/wanrouter/patchlevel: patch does not apply
error: removal patch leaves file contents
error: net/wanrouter/wanmain.c: patch does not apply
error: removal patch leaves file contents
error: net/wanrouter/wanproc.c: patch does not apply
error: removal patch leaves file contents
error: drivers/net/wan/cycx_drv.c: patch does not apply
error: removal patch leaves file contents
error: drivers/net/wan/cycx_main.c: patch does not apply
error: removal patch leaves file contents
error: drivers/net/wan/cycx_x25.c: patch does not apply
error: removal patch leaves file contents
error: include/linux/cyclomx.h: patch does not apply
error: removal patch leaves file contents
error: include/linux/cycx_drv.h: patch does not apply
error: removal patch leaves file contents
error: include/linux/wanrouter.h: patch does not apply
error: removal patch leaves file contents
error: include/uapi/linux/wanrouter.h: patch does not apply
