Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab1CaELX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 00:11:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37832
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab1CaELW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 00:11:22 -0400
Date: Wed, 30 Mar 2011 21:10:44 -0700 (PDT)
Message-Id: <20110330.211044.212408233.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@gaisler.com
Subject: Re: linux-next: build failure after merge of the final tree
 (sparc-current tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110331130127.1d60ba11.sfr@canb.auug.org.au>
References: <20110331130127.1d60ba11.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 31 Mar 2011 13:01:27 +1100

> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/tty/serial/apbuart.c: In function 'apbuart_probe':
> drivers/tty/serial/apbuart.c:568: error: 'struct pdev_archdata' has no member named 'irqs'
> 
> Caused by commit 10544f128c33 ("sparc32, leon: APBUART driver must use
> archdata to get IRQ number").
> 
> I have reverted that commit for today (and commit c897dcf6311e
> "sparc32,leon: Fixed APBUART frequency detection" that conflicts with the
> revert).

Thanks, I'll make apbuart depend upon sparc to fix this.
