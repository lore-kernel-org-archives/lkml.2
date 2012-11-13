Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2KMToN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 14:44:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48536 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab2KMToL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 14:44:11 -0500
Date: Tue, 13 Nov 2012 14:44:06 -0500 (EST)
Message-Id: <20121113.144406.1610017702502358739.davem@davemloft.net>
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
Subject: Re: [PATCH] wanrouter: Remove it and the drivers that depend on it
From: David Miller <davem@davemloft.net>
In-Reply-To: <67fe0c5701a8c7cfe06b178cf04b1c5c06592714.1352548454.git.joe@perches.com>
References: <67fe0c5701a8c7cfe06b178cf04b1c5c06592714.1352548454.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 10 Nov 2012 06:20:55 -0800

> Remove wanrouter as it's obsolete and has not been updated
> by sangoma since 2.4.3 or so and it's not used anymore.
> 
> Remove obsolete cyclomx drivers.
> Update defconfig files that enable wanrouter.
> Update files that include now deleted wanrouter bits.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I'm fine with this change, except the arch defconfig bits.

We've been leaving those alone, and letting the arch maintainers
do the updates themselves periodically.

Please resubmit this with those parts removed.

Thanks.
