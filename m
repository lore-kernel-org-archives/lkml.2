Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1GRTfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:35:45 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56664 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1GRTfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:35:44 -0400
Date: Mon, 18 Jul 2011 12:33:34 -0700 (PDT)
Message-Id: <20110718.123334.586181689043364242.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, iliak@ti.com, padovan@profusion.mobi,
        luiz.von.dentz@intel.com
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110718144138.d57ab0a2a806e06fabbcfc9b@canb.auug.org.au>
References: <20110718144138.d57ab0a2a806e06fabbcfc9b@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Jul 2011 12:33:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 18 Jul 2011 14:41:38 +1000

> Today's linux-next merge of the net tree got a conflict in
> net/bluetooth/l2cap_core.c between commit 9191e6ad897a ("Bluetooth: Fix
> regression in L2CAP connection procedure") from Linus' tree and commit
> e2fd318e3a92 ("Bluetooth: Fixes l2cap "command reject" reply according to
> spec") from the net tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks Stephen, I'll sort this out next time I do a merge between
net-2.6 and net-next-2.6.
