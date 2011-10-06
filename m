Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935314Ab1JFF6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 01:58:41 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43271 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab1JFF6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 01:58:39 -0400
Date: Thu, 06 Oct 2011 01:56:22 -0400 (EDT)
Message-Id: <20111006.015622.2047301950614681216.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: greg@kroah.com, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian.Campbell@citrix.com, netdev@vger.kernel.org, mark.einon@gmail.com
Subject: Re: linux-next: manual merge of the staging tree with the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111006160433.44de2a1374b6ec4efc97e04e@canb.auug.org.au>
References: <20111006160433.44de2a1374b6ec4efc97e04e@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 05 Oct 2011 22:56:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 6 Oct 2011 16:04:33 +1100

> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/et131x/et1310_tx.c between commit bf3f1a6081aa ("et131x:
> convert to SKB paged frag API") from the net tree and commit 10f00a49b048
> ("staging: et131x: Rename var name 'etdev' to 'adapter' throughout
> module") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Yep, we saw this one coming too.  I think you'll need to carry this one
until the merge window flushes out.

Thanks!
