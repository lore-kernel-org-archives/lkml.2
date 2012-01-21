Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab2AUSjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:39:45 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42076 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2AUSjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:39:43 -0500
Date: Sat, 21 Jan 2012 13:39:33 -0500 (EST)
Message-Id: <20120121.133933.227768598621914035.davem@davemloft.net>
To: netdev@pradeepdalvi.com
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] netdev/ethernet: dev_alloc_skb to netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+Dx6HbdHV9qHksqb0oH-zhYdJCm6Tu8btwG1Zs5ty1CPXXckA@mail.gmail.com>
References: <1327156996-12505-1-git-send-email-netdev@pradeepdalvi.com>
	<1327161238.2574.3.camel@edumazet-laptop>
	<CA+Dx6HbdHV9qHksqb0oH-zhYdJCm6Tu8btwG1Zs5ty1CPXXckA@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 21 Jan 2012 10:39:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Date: Sat, 21 Jan 2012 22:16:06 +0530

> I appreciate your concerns. Although I feel, it is essential to add
> relevant comments by respective (corporate/paid :-) developers, if
> their hardware needs hardcoded 2. And especially, if their expectation
> is to buy their hardware, even for the smaller purpose of having
> uniform mechanism. Long live Open Source! :-)

I see the smiley but it is your responsibility to learn how a driver
works before making changes to it that break them.  Stop talking such
foolishness, it is very unbecoming of a serious developer.
