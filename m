Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2I1CTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:19:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32915 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2I1CTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:19:45 -0400
Date: Thu, 27 Sep 2012 22:19:43 -0400 (EDT)
Message-Id: <20120927.221943.19056434713380159.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ivecera@redhat.com
Subject: Re: linux-next: build failure after merge of the net-next tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120928114335.e05b34a5cfe716df86364ccf@canb.auug.org.au>
References: <20120928114335.e05b34a5cfe716df86364ccf@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 28 Sep 2012 11:43:35 +1000

> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/net/ethernet/emulex/benet/be_main.c: In function 'be_find_vfs':
> drivers/net/ethernet/emulex/benet/be_main.c:1090:28: error: 'struct pci_dev' has no member named 'physfn'
> 
> Caused by commit 51af6d7c1f31 ("be2net: fix vfs enumeration").  physfn is
> only defined if CONFIG_PCI_ATS is set.
> 
> I have reverted that commit for today.

I'm reverting it too, thanks for reporting Stephen.
