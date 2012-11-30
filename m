Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab2K3RTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:19:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44639 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab2K3RTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:19:52 -0500
Date: Fri, 30 Nov 2012 12:19:50 -0500 (EST)
Message-Id: <20121130.121950.939471280361329069.davem@davemloft.net>
To: alan@signal11.us
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        eric.dumazet@gmail.com, linux-zigbee-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mac802154: use kfree_skb() instead of
 dev_kfree_skb()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1354249511-8086-2-git-send-email-alan@signal11.us>
References: <504EA95C.9010003@signal11.us>
	<1354249511-8086-1-git-send-email-alan@signal11.us>
	<1354249511-8086-2-git-send-email-alan@signal11.us>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>
Date: Thu, 29 Nov 2012 23:25:11 -0500

> kfree_skb() indicates failure, which is where this is being used.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>

Applied.
