Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0EQF15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:27:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58875
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab0EQF1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:27:55 -0400
Date: Sun, 16 May 2010 22:28:03 -0700 (PDT)
Message-Id: <20100516.222803.226762774.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, jengelh@medozas.de, chrisw@sous-sol.org
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100517120922.50d5e0fb.sfr@canb.auug.org.au>
References: <20100517120922.50d5e0fb.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 17 May 2010 12:09:22 +1000

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> include/linux/if_link.h between commit
> c02db8c6290bb992442fec1407643c94cc414375 ("rtnetlink: make SR-IOV VF
> interface symmetric") from Linus' tree and commit
> 10708f37ae729baba9b67bd134c3720709d4ae62 ("net: core: add IFLA_STATS64
> support") from the net tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix
> for a while.

I'll merge net-2.6 into net-next-2.6 to fix this for you, and
in fact your merge is exactly what I will use.

Thanks!
