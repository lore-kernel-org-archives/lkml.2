Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab2KJXeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 18:34:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46773 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2KJXef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 18:34:35 -0500
Date: Sat, 10 Nov 2012 18:34:31 -0500 (EST)
Message-Id: <20121110.183431.1207459372913956564.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, meravs@broadcom.com, dmitry@broadcom.com,
        eilong@broadcom.com
Subject: Re: linux-next: manual merge of the net-next tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121109105318.e24e2fa2b899af6e4d444b30@canb.auug.org.au>
References: <20121109105318.e24e2fa2b899af6e4d444b30@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 9 Nov 2012 10:53:18 +1100

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c between commit
> 477864ddd365 ("bnx2x: Disable FCoE for 57840 since not yet supported by
> FW") from Linus' tree and commit 55c11941e382 ("bnx2x: Support loading
> cnic resources at run-time") from the net-next tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).

I'm pulling 'net' into 'net-next' and this is exactly how I will resolve
this conflict.  Thanks Stephen.
