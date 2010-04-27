Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab0D0WX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:23:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50552
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755075Ab0D0WX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:23:28 -0400
Date: Tue, 27 Apr 2010 15:23:34 -0700 (PDT)
Message-Id: <20100427.152334.24596525.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
       netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
       gospo@redhat.com, nhorman@tuxdriver.com, jmoyer@redhat.com,
       mpm@selenic.com, bonding-devel@lists.sourceforge.net, fubar@us.ibm.com
Subject: Re: [v4 Patch 2/3] bridge: make bridge support netpoll
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100427075952.4908.60515.sendpatchset@localhost.localdomain>
References: <20100427075937.4908.18468.sendpatchset@localhost.localdomain>
	<20100427075952.4908.60515.sendpatchset@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Tue, 27 Apr 2010 03:55:56 -0400

> +		if (p->dev->priv_flags & IFF_DISABLE_NETPOLL
> +				|| !p->dev->netdev_ops->ndo_poll_controller)

"||" goes on first line, and indentation on second line is incorrect.
See my comments from patch #1.
