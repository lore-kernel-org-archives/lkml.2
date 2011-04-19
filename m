Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1DSHlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:41:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38379
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795Ab1DSHln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:41:43 -0400
Date: Tue, 19 Apr 2011 00:41:08 -0700 (PDT)
Message-Id: <20110419.004108.246512359.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, yanivr@broadcom.com,
        shemminger@vyatta.com
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110419131618.a474326a.sfr@canb.auug.org.au>
References: <20110419131618.a474326a.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 19 Apr 2011 13:16:18 +1000

> Today's linux-next merge of the net tree got a conflict in
> drivers/net/bnx2x/bnx2x_ethtool.c between commit 70dda99c41fc ("bnx2x:
> Fix port identification problem") from the net-current tree and commit
> 32d3613475d8 ("bnx2x: convert to set_phys_id") from the net tree.
> 
> I fixed it up (maybe - see below) and can carry the fix as necessary.

Your conflict resolution was pretty much perfect :-)

I've merged net-2.6 into net-next-2.6 to fix this up.

Thanks!
