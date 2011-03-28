Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1C1Bh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 21:37:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51291
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280Ab1C1Bh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 21:37:58 -0400
Date: Sun, 27 Mar 2011 18:37:19 -0700 (PDT)
Message-Id: <20110327.183719.242146299.davem@davemloft.net>
To: cesarb@cesarb.net
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        eric.dumazet@gmail.com, Tristram.Ha@micrel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: use CHECKSUM_NONE instead of magic number
From: David Miller <davem@davemloft.net>
In-Reply-To: <1301152230-4897-1-git-send-email-cesarb@cesarb.net>
References: <1301152230-4897-1-git-send-email-cesarb@cesarb.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cesar Eduardo Barros <cesarb@cesarb.net>
Date: Sat, 26 Mar 2011 12:10:30 -0300

> Two places in the kernel were doing skb->ip_summed = 0.
> 
> Change both to skb->ip_summed = CHECKSUM_NONE, which is more readable.
> 
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

Applied, thank you.
