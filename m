Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1FCFVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:21:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43509 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1FCFVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:21:05 -0400
Date: Thu, 02 Jun 2011 22:20:51 -0700 (PDT)
Message-Id: <20110602.222051.270790327969020201.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@gaisler.com
Subject: Re: linux-next: build failure after merge of the final tree
 (sparc-current tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110603135347.a17e0b85.sfr@canb.auug.org.au>
References: <20110603135347.a17e0b85.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 02 Jun 2011 22:20:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 3 Jun 2011 13:53:47 +1000

> Caused by commit cfe3af5dde34 ("sparc32: added CONFIG_PCIC_PCI Kconfig
> setting") from the sparc-current tree.
> 
> I have reverted that commit (and the 2 following commits that depend on
> it) for today.

Oops, that needs a sparc32 depencency.  I'll fix that, thanks!
