Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1B1ALf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 19:11:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40003
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985Ab1B1ALd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 19:11:33 -0500
Date: Sun, 27 Feb 2011 16:12:10 -0800 (PST)
Message-Id: <20110227.161210.242134645.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, nhorman@redhat.com,
        herbert@gondor.hengli.com.au, fubar@us.ibm.com, netdev@vger.kernel.org
Subject: Re: [V4 PATCH 1/3] bonding: sync netpoll code with bridge
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298022215-21059-1-git-send-email-amwang@redhat.com>
References: <1298022215-21059-1-git-send-email-amwang@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Fri, 18 Feb 2011 17:43:32 +0800

> V4: rebase to net-next-2.6
> V3: remove an useless #ifdef.
> 
> This patch unifies the netpoll code in bonding with netpoll code in bridge,
> thanks to Herbert that code is much cleaner now.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

Applied.
