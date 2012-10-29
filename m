Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab2J2Rdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:33:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52008 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2J2Rdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:33:40 -0400
Date: Mon, 29 Oct 2012 13:33:38 -0400 (EDT)
Message-Id: <20121029.133338.1308520640627047074.davem@davemloft.net>
To: zheng.x.li@oracle.com
Cc: netdev@vger.kernel.org, fubar@us.ibm.com, andy@greyhouse.net,
        linux-kernel@vger.kernel.org, joe.jin@oracle.com
Subject: Re: [PATCH] bonding: fix bond-6-mode change MAC of arp reply from
 vif to cause Domu's network unreachable intermittently
From: David Miller <davem@davemloft.net>
In-Reply-To: <508E4840.40104@oracle.com>
References: <508E4840.40104@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zheng.li" <zheng.x.li@oracle.com>
Date: Mon, 29 Oct 2012 17:11:28 +0800

> @@ -700,7 +700,18 @@ static struct slave *rlb_arp_xmit(struct sk_buff
> *skb, struct bonding *bond)

You commit message is poorly formatted and your email client corrupted
the patch, making it completely unusable.
