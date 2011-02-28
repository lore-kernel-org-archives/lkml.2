Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1B1ALl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 19:11:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40012
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985Ab1B1ALk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 19:11:40 -0500
Date: Sun, 27 Feb 2011 16:12:16 -0800 (PST)
Message-Id: <20110227.161216.116376267.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, nhorman@redhat.com,
        herbert@gondor.hengli.com.au, fubar@us.ibm.com, horms@verge.net.au,
        jpirko@redhat.com, kaber@trash.net, nhorman@tuxdriver.com,
        eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: [V4 PATCH 2/3] netpoll: remove IFF_IN_NETPOLL flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298022215-21059-2-git-send-email-amwang@redhat.com>
References: <1298022215-21059-1-git-send-email-amwang@redhat.com>
	<1298022215-21059-2-git-send-email-amwang@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Fri, 18 Feb 2011 17:43:33 +0800

> V4: rebase to net-next-2.6
> 
> This patch removes the flag IFF_IN_NETPOLL, we don't need it any more since
> we have netpoll_tx_running() now.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

Applied.
