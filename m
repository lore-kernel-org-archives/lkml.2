Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0D0WWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:22:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50539
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757314Ab0D0WWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:22:31 -0400
Date: Tue, 27 Apr 2010 15:22:36 -0700 (PDT)
Message-Id: <20100427.152236.73676344.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, jmoyer@redhat.com,
       shemminger@linux-foundation.org, bonding-devel@lists.sourceforge.net,
       fubar@us.ibm.com
Subject: Re: [v4 Patch 1/3] netpoll: add generic support for bridge and
 bonding devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100427075937.4908.18468.sendpatchset@localhost.localdomain>
References: <20100427075937.4908.18468.sendpatchset@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Tue, 27 Apr 2010 03:55:41 -0400

> +	if (ndev->priv_flags & IFF_DISABLE_NETPOLL
> +			|| !ndev->netdev_ops->ndo_poll_controller) {

" ||" goes on first line, not second, and second line needs to be indented
properly so that "!ndev->..." matches up with "ndev->priv_flags ..." on
the previous line.
