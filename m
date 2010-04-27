Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0D0WYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:24:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41026
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272Ab0D0WYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:24:18 -0400
Date: Tue, 27 Apr 2010 15:24:24 -0700 (PDT)
Message-Id: <20100427.152424.236240666.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, jmoyer@redhat.com,
       shemminger@linux-foundation.org, bonding-devel@lists.sourceforge.net,
       fubar@us.ibm.com
Subject: Re: [v4 Patch 3/3] bonding: make bonding support netpoll
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100427080004.4908.27339.sendpatchset@localhost.localdomain>
References: <20100427075937.4908.18468.sendpatchset@localhost.localdomain>
	<20100427080004.4908.27339.sendpatchset@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Tue, 27 Apr 2010 03:56:09 -0400

> +		if ((slave->dev->priv_flags & IFF_DISABLE_NETPOLL)
> +				|| !slave->dev->netdev_ops->ndo_poll_controller)

"|| on first line please, plus fix second line's indentation as per
comments given in patch #1 and #2
