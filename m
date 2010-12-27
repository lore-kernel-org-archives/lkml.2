Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab0L0CUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 21:20:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52827
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326Ab0L0CUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 21:20:30 -0500
Date: Sun, 26 Dec 2010 18:21:00 -0800 (PST)
Message-Id: <20101226.182100.71128443.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiaosuo@gmail.com
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101227104144.cedc2d63.sfr@canb.auug.org.au>
References: <20101227104144.cedc2d63.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 27 Dec 2010 10:41:44 +1100

> Today's linux-next merge of the net tree got a conflict in
> net/ipv4/fib_frontend.c between commit
> e058464990c2ef1f3ecd6b83a154913c3c06f02a ("Revert "ipv4: Allow
> configuring subnets as local addresses"") from Linus' tree and commit
> 5811662b15db018c740c57d037523683fd3e6123 ("net: use the macros defined
> for the members of flowi") from the net tree.
> 
> Just context changes (I think).  I fixed it up (see below) and can carry
> the fix as necessary.

Thanks Stephen, I'll take care of this.
