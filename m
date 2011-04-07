Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab1DGUs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 16:48:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59960
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757098Ab1DGUs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 16:48:58 -0400
Date: Thu, 07 Apr 2011 13:48:21 -0700 (PDT)
Message-Id: <20110407.134821.71129934.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, sathya.perla@emulex.com,
        ajit.khaparde@emulex.com
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110407113943.2f054e2f.sfr@canb.auug.org.au>
References: <20110407113943.2f054e2f.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 7 Apr 2011 11:39:43 +1000

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/benet/be_main.c between commit 2d5d41546504 ("be2net: Fix a
> potential crash during shutdown.") from the net-current tree and commit
> 0f4a68288217 ("be2net: cancel be_worker in be_shutdown() even when i/f is
> down") from the net tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

I'll do a merge to clear this up for you, thanks Stephen.
