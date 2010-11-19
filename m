Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0KSVOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:14:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44799
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab0KSVOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:14:18 -0500
Date: Fri, 19 Nov 2010 13:14:43 -0800 (PST)
Message-Id: <20101119.131443.35039425.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101119111706.d68efe13.sfr@canb.auug.org.au>
References: <20101119111706.d68efe13.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 19 Nov 2010 11:17:06 +1100

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/bonding/bond_main.c between commit
> 3006bc38895895f1a0352c2e17e1a503f35f7e2f ("bonding: fix a race in IGMP
> handling") from the net-current tree and commit
> 866f3b25a2eb60d7529c227a0ecd80c3aba443fd ("bonding: IGMP handling
> cleanup") from the net tree.
> 
> I just assumed that the latter is a better solution and used that.

Yep, that's correct, and I'm doing the same as I merge things myself
right now.

Thanks!
