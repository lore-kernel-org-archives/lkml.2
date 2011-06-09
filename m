Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1FII3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:29:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48207 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab1FII3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:29:48 -0400
Date: Thu, 09 Jun 2011 01:29:44 -0700 (PDT)
Message-Id: <20110609.012944.602872260942727070.davem@davemloft.net>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: emaclite: Add missing linux/interrupt.h header
From: David Miller <davem@davemloft.net>
In-Reply-To: <1307607333-24612-1-git-send-email-monstr@monstr.eu>
References: <1307607333-24612-1-git-send-email-monstr@monstr.eu>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 09 Jun 2011 01:29:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>
Date: Thu,  9 Jun 2011 10:15:33 +0200

> Log:
> drivers/net/xilinx_emaclite.c: In function 'xemaclite_open':
> drivers/net/xilinx_emaclite.c:961: error: implicit declaration of function 'request_irq'
> drivers/net/xilinx_emaclite.c: In function 'xemaclite_close':
> drivers/net/xilinx_emaclite.c:995: error: implicit declaration of function 'free_irq'
> make[2]: *** [drivers/net/xilinx_emaclite.o] Error 1
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>

This is only relevant for the -next tree, you should specify that when
submitting patches otherwise the maintainer not apply the patch where
it actually belongs.

Applied, thanks.
