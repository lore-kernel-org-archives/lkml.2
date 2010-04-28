Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab0D1AFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 20:05:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50468
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456Ab0D1AFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 20:05:37 -0400
Date: Tue, 27 Apr 2010 17:05:43 -0700 (PDT)
Message-Id: <20100427.170543.233869422.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, alan@linux.intel.com, joe@perches.com
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100427112827.1f17be40.sfr@canb.auug.org.au>
References: <20100427112827.1f17be40.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 27 Apr 2010 11:28:27 +1000

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/e100.c between commit
> 401da6aea31ef69c2fcd260382adabdcf7ce820a ("e100: Fix the TX workqueue
> race") from Linus' tree and commit
> fa05e1ad1b61b37fb64a66794c11ab478e975c56 ("drivers/net/e100.c: Use
> pr_<level> and netif_<level>") from the net tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix
> for a while.

This should be resolved now that I pulled net-2.6 into net-next-2.6
earlier today.
